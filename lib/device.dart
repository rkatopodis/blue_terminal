import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

import "util.dart";

class Device extends StatelessWidget {

  final Key key;
  final BluetoothDevice device;
  final DeviceSelectionCallback onTap;

  Device({this.key, @required this.device, @required this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.address),
      leading: Icon(
        (device.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_searching)
      ),
      trailing: Icon(Icons.arrow_right),
      onTap: () => onTap(device),
    );
  }
}