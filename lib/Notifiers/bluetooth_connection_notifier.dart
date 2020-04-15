import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothConnectionNotifier with ChangeNotifier {

  BluetoothDevice _connectedDevice;
  set selectedDevice(BluetoothDevice device) => _connectedDevice = device;
  BluetoothDevice get selectedDevice => _connectedDevice;

  BluetoothConnection _connection;

  void connectTo(BluetoothDevice device) {

  }

  void dispose() {
    // Make proper connection clean-up here

    super.dispose();
  }
}