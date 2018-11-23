import 'package:flutter/material.dart';
import '../../widgets/color_loader_2.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//        title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Center(
              heightFactor: 20.0,
              child: Text('Please wait System being Updated'),
            ),
            Center(heightFactor: 1.0, child: ColorLoader2())
          ],
        ),
      ),
    );
  }
}
