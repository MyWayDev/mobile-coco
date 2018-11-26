import 'package:flutter/material.dart';
import 'package:n_gen/models/item.order.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _OrderPage();
  }
}

@override
class _OrderPage extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Card(),
            ),
            Expanded(
                child: model.itemorderlist.length != 0
                    ? ListView.builder(
                        itemCount: model.displayItemOrder.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                              child: Row(
                            children: <Widget>[
                              Text(model.displayItemOrder[i].itemId + '  '),
                              Text(model.displayItemOrder[i].price.toString() +
                                  '  '),
                              Text(model.displayItemOrder[i].qty.toString() +
                                  '  '),
                              Text(i.toString()),
                            ],
                          ));
                        },
                      )
                    : Text('Empty')),
          ],
        ),
      );
    });
  }
}
