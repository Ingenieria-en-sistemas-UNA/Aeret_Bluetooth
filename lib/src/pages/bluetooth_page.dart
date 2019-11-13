import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:aeret_bluetooth/src/bloc/provider.dart';
import 'package:aeret_bluetooth/src/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:aeret_bluetooth/src/components/select_devices_box_widget.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('AERET'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 10),
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
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      image: AssetImage('assets/img/medicamento.png'),
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: _bluetoothBloc.readStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      String s = new String.fromCharCodes(snapshot.data);
                      print('STREAM $s');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Estado:', style: TextStyle(fontSize: 16.0)),
                          s != '9' ? (
                            s == '1'
                              ? (Text(' Abierto',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.green)))
                              : (Text(' Cerrado',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.redAccent)))
                          ) : (
                            Text(' Desactivado',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.redAccent))
                          )
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Estado:', style: TextStyle(fontSize: 16.0)),
                        _connected ? (
                          Text(' Esperando...',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.blueAccent))
                        ): (
                          Text(' Desactivado',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.redAccent))
                        )
                        
                      ],
                    );
                  },
                ),
                Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.all(30.0),
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    child: Text('Abrir', style: TextStyle(fontSize: 20.0)),
                    onPressed:
                        _connected ? () => _bluetoothBloc.write('1') : null,
                  ),
                ),
                Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.all(30.0),
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    child: Text('Cerrar', style: TextStyle(fontSize: 20.0)),
                    onPressed:
                        _connected ? () => _bluetoothBloc.write('0') : null,
                  ),
                ),
              ],
            ),
          ),
          //_createButtonsLed(),
        ],
      ),
    );
  }

  Widget _createButtonsLed() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
    var isConnected = await _bluetoothBloc.connect();
    if (isConnected) {
      setState(() {
        _connected = true;
        _pressed = false;
      });
    } else {
      showSnackbar('Seleccione un dispositivo');
    }
  }

  void _disconnect() async {
    var isDisconnected = await _bluetoothBloc.disconnect();
    if (isDisconnected) {
      setState(() {
        _connected = false;
        _pressed = false;
      });
    } else {
      showSnackbar('Seleccione un dispositivo');
    }
  }

  void showSnackbar(String mensaje) {
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.redAccent,
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  void dispose() {
    _bluetoothBloc.disconnect().then((boo) {
      super.dispose();
    });
  }
}
