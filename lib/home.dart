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
  StreamController<BluetoothDiscoveryResult> _discoveryController;
  List<BluetoothDiscoveryResult> _discoveryResults = List();
  bool _discoveryOngoing = false;

  void _discover() {
    setState(() {
      // _discoveryController = StreamController()
      // ..addStream(
      //   FlutterBluetoothSerial.instance.startDiscovery()
      // );
      // _discoveryController.onListen = () => setState(() => _discoveryOngoing = true);
      // _discoveryController.done
      // ..then((_) => setState(() => _discoveryOngoing = false))
      // ..then((_) => print("Hey! I'm done discovering!"));

      // // For testing purposes only
      // _discoveryController.stream.listen(
      //   (device) => print(device.device.name),
      //   onDone: () {
      //     print("For sure I'm done discovering now!");
      //     setState(() => _discoveryOngoing = false);
      //   }
      // );
      // _discoveryController.onCancel = () => print("Hey! I've been canceled!");
      // // Finish test
      _discoveryOngoing = true;
      _discoveryResults.clear();
      FlutterBluetoothSerial.instance.startDiscovery()
      .listen(
        (BluetoothDiscoveryResult result) {
          _discoveryResults.add(result);
          print(result.device.name);
        },
        onDone: () {
          print("Surely we are done now!");
          setState(() => _discoveryOngoing = false);
        }
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // Create FlutterBluetoothTerminal and request the bluetooth
    // receiver to be enabled
    FlutterBluetoothSerial.instance.requestEnable();

    // Make a first search for devices when bluetooth is on
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _btState = state;
      });

      if (state == BluetoothState.STATE_ON) {
        _discover();
      } else {
        // If the bluetooth receiver is not on, schedule a search for when it turns on
        FlutterBluetoothSerial.instance.onStateChanged().listen(
          (BluetoothState state) {
            setState(() {
              _btState = state;
            });

            if (state == BluetoothState.STATE_ON) {
              _discover();
            }
          }
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.bluetooth),
        title: Text('Bluetooth Terminal'),
        actions: <Widget>[
          DiscoverButton(state: _btState, discoveryOngoing: _discoveryOngoing, onPressed: () {},),
        ],
      ),
      body: SafeArea(
        child: DeviceList(
          state: _btState,
          devices: _discoveryResults.map((result) => result.device).toList()
        ),
      ),
    );
  }
}