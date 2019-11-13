import 'package:flutter/material.dart';

import 'package:aeret_bluetooth/src/bloc/provider.dart';
import 'package:aeret_bluetooth/src/pages/bluetooth_page.dart';

void main()  => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aeret',
        initialRoute: 'bluetooth',
        routes: {
          'bluetooth': (BuildContext context) => BluetoothPage(),
        },
      ),
    );
  }
}
