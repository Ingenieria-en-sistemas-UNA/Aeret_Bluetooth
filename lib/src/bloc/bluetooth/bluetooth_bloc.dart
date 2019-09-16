

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothBloc {

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  final _bluetoothConnectionController = new BehaviorSubject<BluetoothConnection>();
  final _bluetoothDevicesListController = new BehaviorSubject<List<BluetoothDevice>>();
  final _bluetoothDeviceController = new BehaviorSubject<BluetoothDevice>();
  final _cargandoController = new BehaviorSubject<bool>();

  Stream<BluetoothConnection> get bluetoothConnectionStream => _bluetoothConnectionController.stream;
  Stream<List<BluetoothDevice>> get bluetoothDevicesListStream => _bluetoothDevicesListController.stream;
  Stream<BluetoothDevice> get bluetoothDeviceStream => _bluetoothDeviceController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  Function(BluetoothConnection) get bluetoothConnectionSink => _bluetoothConnectionController.sink.add;
  Function(List<BluetoothDevice>) get bluetoothDevicesListSink => _bluetoothDevicesListController.sink.add;
  Function(BluetoothDevice) get bluetoothDeviceSink => _bluetoothDeviceController.sink.add;


  BluetoothConnection get bluetoothConnection => _bluetoothConnectionController.value;
  List<BluetoothDevice> get bluetoothDevicesList => _bluetoothDevicesListController.value;
  BluetoothDevice get bluetoothDevice => _bluetoothDeviceController.value;
  bool get isConnected => bluetoothConnection.isConnected ?? false;
  

  Future<void> loadDevices() async {
    try{
      var devices = await bluetooth.getBondedDevices();
      bluetoothDevicesListSink(devices);
    } on PlatformException {
      print('error');
    }
  }

  Future<void> setDevice(BluetoothDevice device) async {
    bluetoothDeviceSink(device);
  }



  Future<void> write(String value) async {
    if(isConnected){
      bluetoothConnection.output.add(utf8.encode(value));
    }
  }
  
  Future<void> connect() async {
    if(bluetoothDevice != null) {
      var connection = await BluetoothConnection.toAddress(bluetoothDevice.address);
      bluetoothConnectionSink(connection); 
    }    
  }

  Future<void> disconnect() async {
    if(isConnected){
      await bluetoothConnection.finish();
      bluetoothConnectionSink(null);
      bluetoothDeviceSink(null);
    }
  }

  void dispose() {
    _bluetoothConnectionController?.close();
    _bluetoothDevicesListController?.close();
    _bluetoothDeviceController?.close();
    _cargandoController?.close();
  }

}