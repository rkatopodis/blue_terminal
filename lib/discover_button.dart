import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DiscoverButton extends StatelessWidget {

  final Key key;
  final BluetoothState state;
  final bool discoveryOngoing;
  final VoidCallback onPressed;

  DiscoverButton({
    this.key,
    @required this.state,
    @required this.discoveryOngoing,
    @required this.onPressed
  }): super(key: key);

  @override
  Widget build(BuildContext build) {
    // If bluetooth is not enabled, show a disabled icon
    if (state != BluetoothState.STATE_ON) {
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
    } else if (discoveryOngoing) {
      // ProgressIndicator
      return FittedBox(
        child: Container(
          margin: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Refresh icon
      return IconButton(icon: Icon(Icons.refresh), onPressed: onPressed);
    }
  }
}