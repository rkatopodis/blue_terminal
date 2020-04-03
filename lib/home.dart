import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

import "discover_button.dart";
import "device_list.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  BluetoothState _btState = BluetoothState.UNKNOWN;
  StreamSubscription<BluetoothDiscoveryResult> _discoverySubscription;
  List<BluetoothDevice> _discoveryResults = List<BluetoothDevice>();
  bool _discoveryOngoing = false;

  void _discover() {
    _cancelDiscovery();
    setState(() {
      _discoveryOngoing = true;
      _discoveryResults.clear();
      _discoverySubscription = FlutterBluetoothSerial.instance.startDiscovery()
      .listen(
        (BluetoothDiscoveryResult result) {
          setState(() => _discoveryResults.add(result.device));
          print(result.device.name);
        },
        onDone: () {
          print("Surely we are done now!");
          setState(() => _discoveryOngoing = false);
        },
        onError: (error) {
          print("Oh-Oh! An error occurred!");
          print("$error");
          setState(() => _discoveryOngoing = false);
        },
        cancelOnError: true
      );
    });
  }

  void _cancelDiscovery() {
    _discoverySubscription?.cancel();
    setState(() => _discoveryOngoing = false);
  }

  @override
  void initState() {
    super.initState();
    // Create FlutterBluetoothTerminal and request the bluetooth
    // receiver to be enabled
    FlutterBluetoothSerial.instance.requestEnable();

    // Monitor changes in bluetooth state 
    FlutterBluetoothSerial.instance.onStateChanged().listen(
      (BluetoothState state) {
        setState(() {
          _btState = state;
        });

        if (state == BluetoothState.STATE_ON) {
          _discover();
        } else if (state == BluetoothState.STATE_OFF) {
          _cancelDiscovery();
        }
      }
    );

    // Make a first search for devices when bluetooth is on
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _btState = state;
      });

      if (state == BluetoothState.STATE_ON) {
        _discover();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Terminal'),
        actions: <Widget>[
          DiscoverButton(state: _btState, discoveryOngoing: _discoveryOngoing, onRefresh: _discover, onCancel: _cancelDiscovery),
        ],
      ),
      body: SafeArea(
        child: DeviceList(
          state: _btState,
          devices: _discoveryResults
        ),
      ),
    );
  }
}