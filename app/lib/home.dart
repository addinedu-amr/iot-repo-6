import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_example/MainPage.dart';
import 'package:flutter_bluetooth_serial_example/example.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings_bluetooth, color: Colors.white),
            onPressed: () {
              Navigator.push(context2,
                  MaterialPageRoute(builder: (context) => MainPage()));
            },
          )
        ],
        title: Text('Smart Control'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Example(),
    );
  }
}
