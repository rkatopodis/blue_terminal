import 'dart:collection';

import 'package:flutter/foundation.dart';
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

class BluetoothNotifier with ChangeNotifier {

  BluetoothState _bt_state = BluetoothState.UNKNOWN;
  BluetoothState get state => _bt_state;

  bool _isDiscovering = false;
  bool get isDiscovering => _isDiscovering;

  List<BluetoothDevice> _devices = [];
  UnmodifiableListView<BluetoothDevice> get devices => UnmodifiableListView(_devices);


  BluetoothNotifier() {
    // // Create FlutterBluetoothTerminal and request the bluetooth
    // // receiver to be enabled
    // FlutterBluetoothSerial.instance.requestEnable();

    // // Monitor changes in bluetooth state 
    // FlutterBluetoothSerial.instance.onStateChanged().listen(
    //   (BluetoothState state) {
    //     _bt_state = state;
    //     print('BT state is $state');
    //     notifyListeners();

    //     if (state == BluetoothState.STATE_ON) {
    //       discover();
    //     } else if (state == BluetoothState.STATE_OFF) {
    //       _cancelDiscovery();
    //     }
    //   }
    // );

    // // Make a first search for devices when bluetooth is on
    // FlutterBluetoothSerial.instance.state.then((state) {
    //   setState(() {
    //     _btState = state;
    //   });

    //   if (state == BluetoothState.STATE_ON) {
    //     _discover();
    //   }
    // });
  }
  

  Future<void> discover() async {
    _isDiscovering = true;
    notifyListeners();

    
  }

}