import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:blue_terminal/alt_discover_button.dart';
import 'package:blue_terminal/alt_device_list.dart';
import 'package:provider/provider.dart';

import 'Notifiers/bluetooth_discovery_notifier.dart';

class AltHome extends StatelessWidget {

  final Key key;

  AltHome({this.key}): super(key: key) {
    // Create FlutterBluetoothTerminal and request the bluetooth
    // receiver to be enabled
    FlutterBluetoothSerial.instance.requestEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blue Terminal"),
        actions: <Widget>[
          AltDiscoverButton()
        ],
      ),
      body: SafeArea(
        child: AltDeviceList()
      )
    );
  }
}