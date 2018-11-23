import 'package:flutter/material.dart';
import '../scoped/connected.dart';

class Welcome extends StatelessWidget {
  final MainModel model = MainModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcomeScreen')),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(right: 10.0),
          child: FlatButton.icon(
            label: Text('Logout'),
            icon: Icon(
              Icons.backspace,
              size: 20.0,
            ),
            onPressed: () {
              model.signOut();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
      ),
    );
  }
}
