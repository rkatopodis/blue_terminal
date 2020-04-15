import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blue_terminal/alt_home.dart';
import 'package:blue_terminal/Notifiers/bluetooth_discovery_notifier.dart';

import 'Notifiers/bluetooth_state_notifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothStateNotifier()),
        ChangeNotifierProxyProvider<BluetoothStateNotifier, BluetoothDiscoveryNotifier>(
          create: (_) => BluetoothDiscoveryNotifier(),
          update: (_, stateNotifier, discoveryNotifer) => discoveryNotifer..update(stateNotifier.state)
        )
      ],
      child: MaterialApp(
        title: 'Blue Terminal',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: AltHome()
      ),
    );
  }
}