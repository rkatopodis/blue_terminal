import 'dart:collection';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDiscoveryNotifier with ChangeNotifier {
  StreamSubscription<BluetoothDiscoveryResult> _discoverySubscription;

  bool _isDiscovering = false;
  bool get isDiscovering => _isDiscovering;

  List<BluetoothDevice> _discoveredDevices = [];
  UnmodifiableListView<BluetoothDevice> get discoveredDevices => UnmodifiableListView(_discoveredDevices);

  Future<void> startDiscovery() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;

    if (state != BluetoothState.STATE_ON || _isDiscovering)
      return;

    _isDiscovering = true;
    _discoveredDevices.clear();
    notifyListeners();

    _discoverySubscription = FlutterBluetoothSerial.instance.startDiscovery()
    .listen(
      (BluetoothDiscoveryResult result) {
        _discoveredDevices.add(result.device);
        notifyListeners();
        print(result.device.name);
      },
      onDone: () {
        print("Surely we are done now!");
        _isDiscovering = false;
        notifyListeners();
      },
      onError: (error) {
        print("Oh-Oh! An error occurred!");
        print("$error");
        _isDiscovering = false;
        notifyListeners();
      },
      cancelOnError: true
    );
  }

  Future<void> cancelDiscovery() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;
    if (state != BluetoothState.STATE_ON || !_isDiscovering)
      return;

    print("Canceling discovery");

    _discoverySubscription?.cancel();
    _isDiscovering = false;
    notifyListeners();
  }

  // Handles cases involving BT state change
  void update(BluetoothState state) {
    if (state == BluetoothState.STATE_ON)
      startDiscovery();
    else if (state == BluetoothState.STATE_OFF)
      cancelDiscovery();
  }
}