import 'package:blue_terminal/Notifiers/bluetooth_discovery_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'Notifiers/bluetooth_state_notifier.dart';

class AltDiscoverButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<BluetoothStateNotifier, BluetoothDiscoveryNotifier>(
      builder: (context, stateNotifier, discoveryNotifier, _) {
        print("Curent state according to AltDiscoveryButton is $stateNotifier.state!!!");
        if (stateNotifier.state != BluetoothState.STATE_ON) {
          // Disabled icon
          return FittedBox(
            child: Container(
              margin: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(
                value: 0,
                backgroundColor: Colors.grey,
              )
            )
          );
        } else if (discoveryNotifier.isDiscovering) {
          // ProgressIndicator
          return GestureDetector(
            onTap: discoveryNotifier.cancelDiscovery,
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          // Refresh icon
          return IconButton(icon: Icon(Icons.refresh), onPressed: discoveryNotifier.startDiscovery);
        }
      }
    );
  }
}