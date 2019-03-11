import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:n_gen/models/item.dart';
import 'package:n_gen/pages/items/item.details.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/widgets/stock_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class IconBar extends StatefulWidget {
  final List<Item> itemData;
  final int index;
  IconBar(this.itemData, this.index);
  @override
  State<StatefulWidget> createState() {
    return _IconBar();
  }
}

@override
class _IconBar extends State<IconBar> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ButtonBar(
            children: <Widget>[
              !model.cartLocked
                  ? BadgeIconButton(
                      itemCount: model.iCount(widget.index),
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.pink[900],
                        size: 36.0,
                      ),
                      // required
                      //badgeColor: Colors.pink[900],
                      badgeTextColor: Colors.white,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (_) => StockDialog(widget.itemData,
                                widget.index, model.iCount(widget.index)));
                      },
                    )
                  : BadgeIconButton(
                      itemCount: model.iCount(widget.index),
                      icon: Icon(
                        Icons.remove_shopping_cart,
                        color: Colors.grey,
                        size: 36.0,
                      ),
                      // required
                      //badgeColor: Colors.pink[900],
                      badgeTextColor: Colors.white,
                      onPressed: () {}),
              /* IconButton( //! order icon before badgeIcon implementation up!
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 36.0,
                  color: Colors.pink[900],
                  onPressed: () async {
                    showDialog(
                        // barrierDismissible: false,
                        context: context,
                        builder: (_) =>
                            StockDialog(widget.itemData, widget.index));
                  }),*/
              Padding(
                padding: EdgeInsets.only(left: 11.0, right: 11.0),
              ),
              IconButton(
                  icon: Icon(Icons.info_outline),
                  iconSize: 36.0,
                  color: Colors.blueAccent,
                  onPressed:
                      () {} /* () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemDetails(widget.itemData[widget.index])));
                  }*/
                  ),
              /* IconButton(
                  // !delete this mock icon;
                  icon: Icon(Icons.code),
                  iconSize: 24.0,
                  color: Colors.redAccent,
                  onPressed: () {
                    model.mockOrder(widget.itemData[widget.index], 21);
                  }),*/
            ],
          )
        ],
      );
    });
  }
}
