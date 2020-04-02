import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothStatus extends StatefulWidget {
  @override
  BluetoothStatusState createState() => BluetoothStatusState();
}

class BluetoothStatusState extends State<BluetoothStatus> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  @override
  void initState() {
    super.initState();

    // Request bluetooth to turn on
    FlutterBluetoothSerial.instance.requestEnable();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() => _bluetoothState = state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Status is $_bluetoothState'),
    );
  }
}
