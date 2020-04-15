import 'dart:collection';

import 'package:blue_terminal/Notifiers/bluetooth_discovery_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:blue_terminal/alt_device.dart';

import 'Notifiers/bluetooth_state_notifier.dart';

class AltDeviceList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final BluetoothState state = Provider.of<BluetoothStateNotifier>(context).state;
    final UnmodifiableListView devices = Provider.of<BluetoothDiscoveryNotifier>(context).discoveredDevices;

    // Displays a warning message in case bluetooth receiver
    // is off
    if (state != BluetoothState.STATE_ON) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_disabled),
            onPressed: FlutterBluetoothSerial.instance.requestEnable,
            iconSize: 72,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 12.0),
            child: Text(
              "Your bluetooth seems to be disabled. Tap on the icon above to turn it on",
              textAlign: TextAlign.center,
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)
            ),
          ),
        ],
      );
    } else {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) => AltDevice(
          device: devices[index],
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: devices.length
      );
    }
  }
}