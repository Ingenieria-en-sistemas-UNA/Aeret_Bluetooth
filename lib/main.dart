import 'package:aeret_bluetooth/src/bloc/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeret_bluetooth/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aeret',
        initialRoute: 'home',
        routes: {'home': (BuildContext context) => HomePage()},
      ),
    );
  }
}
