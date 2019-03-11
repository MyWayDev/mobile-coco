import 'package:flutter/material.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class LegacySync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Container(
            padding: EdgeInsets.only(right: 10.0),
            child: FlatButton.icon(
              label: Text('Test Code'),
              icon: Icon(
                Icons.playlist_add_check,
                size: 30.0,
              ),
              onPressed: () {
                // model.fbItemList();
                model.fbItemsUpdateFromDb();
                //    model.getArea();
                //  model.stageToProduction();
                //  model.itemsAndImageAssembly();
              },
            ),
          ),
        ),
      );
    });
  }
}
