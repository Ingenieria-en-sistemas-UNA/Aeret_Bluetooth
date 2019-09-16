import 'package:aeret_bluetooth/src/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DropdownDevicesWidget extends StatelessWidget {
  final List<BluetoothDevice> devices;

  DropdownDevicesWidget({@required this.devices});

  @override
  Widget build(BuildContext context) {
    var bluetoothBloc = Provider.ofBluetoothBloc(context);

    return StreamBuilder(
        stream: bluetoothBloc.bluetoothDeviceStream,
        builder: (context, AsyncSnapshot<BluetoothDevice> snapshot) {
          return DropdownButton(
            items: _getDeviceItems(),
            onChanged: (BluetoothDevice value) {
              bluetoothBloc.bluetoothDeviceSink(value);
            },
            value: snapshot.data,
          );
        });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('Ninguno'),
      ));
    } else {
      devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }
}
