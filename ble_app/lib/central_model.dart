import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CentralModel extends ChangeNotifier {

  final _connectToLocalName = 'M5Stack-Color';
  final _timeout = 4;
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice _device;
  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;
  String receiveString = 'none';
  List<int> receiveRaw = [];

  void scanDevices() {
    // Start scanning
    _flutterBlue.startScan(timeout: Duration(seconds: _timeout));
    // Listen to scan results
    var subscription = _flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name == _connectToLocalName) {
          //デバイスを発見したのでここでデバイス情報を保持する
          if (_device == null) {
            _device = r.device;
            notifyListeners();
            await connect();
            break;
          }
        }
      }
    });
    // Stop scanning
    _flutterBlue.stopScan();
  }

  void connect() async {
    await _device.connect();
    print('connect');

    List<BluetoothService> services = await _device.discoverServices();
    services.forEach((service) async {
      // do something with service
      service.characteristics.forEach((characteristic) async {
        if (characteristic.properties.write) {
          _writeCharacteristic = characteristic;
          print('write');
        } else if (characteristic.properties.notify) {
          _notifyCharacteristic = characteristic;
          await _notifyCharacteristic.setNotifyValue(true);
          _notifyCharacteristic.value.listen((value) {
            // do something with new value
            receiveRaw = value;
            receiveString = utf8.decode(value);
            print('recevied:${receiveString}');
            notifyListeners();
          });
          print('notify');
        }
      });
    });
  }

  void disconnect() {
    _device.disconnect();
    _device = null;
    _writeCharacteristic = null;
    _notifyCharacteristic = null;
    print('disconnect');
    notifyListeners();
  }

  void write(List<int> message) {
    if (_writeCharacteristic != null) {
      _writeCharacteristic.write(message);
    }
  }

  void writeString(String message) {
    if (_writeCharacteristic != null) {
      _writeCharacteristic.write(utf8.encode(message));
    }
  }

  bool isConnected() {
    if (_device == null) {
      return false;
    }
    return true;
  }
}
