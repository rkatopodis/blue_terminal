import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'BluetoothDeviceListEntry.dart';

class BluetoothDevices extends StatefulWidget {
  @override
  BluetoothDevicesState createState() => BluetoothDevicesState();
}

class BluetoothDevicesState extends State<BluetoothDevices> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering = true;

  @override
  void initState() {
    super.initState();

     _startDiscovery();
  }

  void restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() { results.add(r); });
    });

    _streamSubscription.onDone(() {
      setState(() { isDiscovering = false; });
    });
  }

  @override 
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, index) {
        BluetoothDiscoveryResult result = results[index];
        return BluetoothDeviceListEntry(
          device: result.device,
          rssi: result.rssi,
          onTap: () {
            Navigator.of(context).pop(result.device);
          },
          onLongPress: () async {
            try {
              bool bonded = false;
              if (result.device.isBonded) {
                print('Unbonding from ${result.device.address}...');
                await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(result.device.address);
                print('Unbonding from ${result.device.address} has succed');
              }
              else {
                print('Bonding with ${result.device.address}...');
                bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(result.device.address);
                print('Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
              }
              setState(() {
                results[results.indexOf(result)] = BluetoothDiscoveryResult(
                  device: BluetoothDevice(
                    name: result.device.name ?? '',
                    address: result.device.address,
                    type: result.device.type,
                    bondState: bonded ? BluetoothBondState.bonded : BluetoothBondState.none,
                  ), 
                  rssi: result.rssi
                );
              });
            }
            catch (ex) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error occured while bonding'),
                    content: Text("${ex.toString()}"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        );
      },
    );
  }
}
