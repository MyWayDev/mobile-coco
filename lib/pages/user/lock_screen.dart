import 'package:flutter/material.dart';
import 'package:n_gen/models/lock.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/widgets/login/login_screen_banner.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../widgets/color_loader_2.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
              ),
              Image.asset(
                'assets/images/myway.png',
                scale: 1.8,
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
              ),
              Center(heightFactor: 1.0, child: ColorLoader2())
            ],
          ),
        ),
      );
    });
  }
}
