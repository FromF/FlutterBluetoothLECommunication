import 'package:ble_app/central.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text(
              'Select BLE Mode:',
            ),
            const SizedBox(height: 30,width: double.infinity,),
            RaisedButton(
              onPressed:  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Central(title: title,)),
                );
              },
              child: const Text('Central', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed:  () {

              },
              child: const Text('Peripheral', style: TextStyle(fontSize: 20)),
            ),

          ],
        ),
      ),
    );
  }
}
