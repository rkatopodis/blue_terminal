import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothStateNotifier with ChangeNotifier {
  BluetoothState _state = BluetoothState.UNKNOWN;
  BluetoothState get state => _state;

  StreamSubscription<BluetoothState> _stateChangeSubscription;

  BluetoothStateNotifier() {
    // Find out initial state
    FlutterBluetoothSerial.instance.state.then(
      (currentState) {
        _state = currentState;
        notifyListeners();
      },
      onError: (error) {
        print('Error occurred while trying to acertain the current BT state: $error');
      }
    );

    // Notify when state changes
    _stateChangeSubscription = FlutterBluetoothSerial.instance.onStateChanged().listen(
      (state) {
        _state = state;
        notifyListeners();
      },
      onError: (error) => print("Error occurred while listening for BT state changes: $error"),
      onDone: () => print("BT state stream finished. Is this an error?")
    );
  }

  @override
  void dispose() {
    _stateChangeSubscription?.cancel();
    super.dispose();
  }
}