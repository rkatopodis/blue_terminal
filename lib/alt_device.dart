import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

import "package:blue_terminal/chat.dart";

class AltDevice extends StatelessWidget {

  final Key key;
  final BluetoothDevice device;

  AltDevice({this.key, @required this.device}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.address),
      leading: Icon(
        (device.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_searching)
      ),
      trailing: Icon(Icons.arrow_right),
      onTap: () => _selectDevice(context, device),
    );
  }

  void _selectDevice(BuildContext context, BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Chat(device: device);
        }
      ),
    );
  }
}