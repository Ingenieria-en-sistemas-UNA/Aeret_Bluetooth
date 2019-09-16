import 'package:aeret_bluetooth/src/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {

  static Provider _intance;

  final _bluetoothBloc = new BluetoothBloc();
  
  factory Provider({ Key key, Widget child }) {
    if( _intance == null ) {
      _intance =  new Provider._internal(key: key, child: child);
    } 
    return _intance;
  }

  Provider._internal({ Key key, Widget child }) : super( key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BluetoothBloc ofBluetoothBloc( BuildContext context ) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider)._bluetoothBloc;
  }

}