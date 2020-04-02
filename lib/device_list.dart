import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

class DeviceList extends StatelessWidget {

  final Key key;
  final BluetoothState state;
  final List<BluetoothDevice> devices;

  DeviceList({this.key, @required this.state, @required this.devices}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // Displays a warning message in case bluetooth receiver
    // is off
    if (state != BluetoothState.STATE_ON) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth_disabled),
            onPressed: FlutterBluetoothSerial.instance.requestEnable,
            iconSize: 72,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 12.0),
            child: Text(
              "Your bluetooth seems to be disabled. Tap on the icon above to turn it on",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(devices[index].name),
          subtitle: Text(devices[index].address),
          leading: Icon(
            (devices[index].isConnected ? Icons.bluetooth_connected : Icons.bluetooth_searching)
          ),
          trailing: Icon(Icons.arrow_right),
          onTap: () => {},
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: devices.length
      );
    }
  }
}