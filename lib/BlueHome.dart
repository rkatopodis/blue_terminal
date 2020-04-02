import 'package:flutter/material.dart';
import 'BluetoothDevices.dart';

class BlueHome extends StatelessWidget {
  final _devices = BluetoothDevices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blue Terminal'),
        actions: <Widget>[
          (
            _devices.createState().isDiscovering ?
              FittedBox(child: Container(
                margin: new EdgeInsets.all(16.0),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              ))
            :
              IconButton(
                icon: Icon(Icons.replay),
                onPressed: _devices.createState().restartDiscovery
              )
          )
        ],
      ),
      /*body: ListView(
        children: <Widget>[
          BluetoothStatus(),
          BluetoothDevices()
        ],
      )*/
      body: Container(
        child: _devices
      )
    );
  }
}
