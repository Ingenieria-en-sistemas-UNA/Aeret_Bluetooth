import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dropdown_devices_widget.dart';
import 'package:aeret_bluetooth/src/bloc/provider.dart';


class SelectDevicesBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var bluetoothBloc = Provider.ofBluetoothBloc(context);

    return StreamBuilder(
      stream: bluetoothBloc.bluetoothDevicesListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        var devices = snapshot.data;
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Dispositivo:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownDevicesWidget(
                  devices: devices,
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}