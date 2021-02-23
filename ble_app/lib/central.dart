import 'package:ble_app/central_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Central extends StatelessWidget {
  Central({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CentralModel>(
      create: (_) => CentralModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Consumer<CentralModel>(builder: (context, model, child) {
          return  Stack(
            children: [
              _background(),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Central Mode:',
                    ),
                    Text(
                      '${model.receiveString}',
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 30,width: double.infinity,),
                    RaisedButton(
                      onPressed:  () {
                        if (model.isConnected() == true) {
                          model.disconnect();
                        } else {
                          model.scanDevices();
                        }
                      },
                      child: Text(
                        (model.isConnected() == true ? 'Disconnect' : 'Connect'),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed:  () {
                            // model.write([82,69,68]);
                            model.writeString('RED');
                          },
                          child: const Text('RED', style: TextStyle(fontSize: 20)),
                        ),
                        RaisedButton(
                          onPressed:  () {
                            // model.write([89,69,76,76,79,87]);
                            model.writeString('YELLOW');
                          },
                          child: const Text('YELLOW', style: TextStyle(fontSize: 20)),
                        ),
                        RaisedButton(
                          onPressed:  () {
                            // model.write([66,76,85,69]);
                            model.writeString('BLUE');
                          },
                          child: const Text('BLUE', style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _background() {
    return Consumer<CentralModel>(builder: (context, model, child) {
      if (model.receiveString == 'RED') {
        return Container(
          color: Colors.red,
        );
      } else if (model.receiveString == 'YELLOW') {
        return Container(
          color: Colors.yellow,
        );
      } else if (model.receiveString == 'BLUE') {
        return Container(
          color: Colors.blue,
        );
      }
      return Container();
    });
  }
}
