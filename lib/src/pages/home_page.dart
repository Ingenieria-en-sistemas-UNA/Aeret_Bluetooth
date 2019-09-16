import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:aeret_bluetooth/src/bloc/provider.dart';
import 'package:aeret_bluetooth/src/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:aeret_bluetooth/src/components/select_devices_box_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  BluetoothBloc _bluetoothBloc;

  bool _pressed = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    bluetooth.onStateChanged().listen((state) {
      if (state.isEnabled) {
        setState(() {
          _connected = true;
          _pressed = false;
        });
      } else {
        setState(() {
          _connected = false;
          _pressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _bluetoothBloc = Provider.ofBluetoothBloc(context);
    _bluetoothBloc.loadDevices();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Emparejar Dispositivo",
              style: TextStyle(fontSize: 24, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ),
          SelectDevicesBoxWidget(),
          RaisedButton(
            onPressed: _pressed ? null : _connected ? _disconnect : _connect,
            child: Text(_connected ? 'Desconectado' : 'Conectar'),
          ),
          _createButtonsLed(),
        ],
      ),
    );
  }

  Widget _createButtonsLed() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Dispositivo",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ),
              FlatButton(
                onPressed: _connected ? () => _bluetoothBloc.write('1') : null,
                child: Text("ON"),
              ),
              FlatButton(
                onPressed: _connected ? () => _bluetoothBloc.write('0') : null,
                child: Text("OFF"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _connect() async {
    await _bluetoothBloc.connect();
    setState(() {
      _connected = true;
      _pressed = false;
    });
  }

  void _disconnect() async {
    await _bluetoothBloc.disconnect();
    setState(() {
      _pressed = false;
      _connected = false;
    });
  }
}
