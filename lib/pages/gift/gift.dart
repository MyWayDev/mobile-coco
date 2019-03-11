import 'package:badges/badges.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class GiftPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GiftPage();
  }
}

void giftState(MainModel model) async {
  await model.checkGift(model.orderBp(), model.giftBp());
  model.getGiftPack();
}

@override
class _GiftPage extends State<GiftPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: model.giftorderList.length > 0
            ? Column(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemCount: model.giftorderList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Dismissible(
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.endToStart) {
                          model.deleteGiftOrder(i);
                          setState(() {
                            giftState(model);
                          });
                          //model.giftpackorderlist.length;
                        } else if (direction == DismissDirection.startToEnd) {
                          model.deleteGiftOrder(i);
                          setState(() {
                            giftState(model);
                          });
                          // model.giftpackorderlist.length;
                        }
                      },
                      background: Container(
                        color: Color(0xFFFFFFF1),
                      ),
                      key: Key(model.giftorderList[i].bp.toString()),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            trailing: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: NetworkImage(
                                model.giftorderList[i].imageUrl,
                              ),
                            ),
                            title: Text(model.giftorderList[i].desc,
                                textAlign: TextAlign.right),
                            leading: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: BadgeIconButton(
                                  itemCount: model.gCount(i),
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.pink[900],
                                    size: 0.0,
                                  ), // required
                                  //badgeColor: Colors.pink[900],
                                  badgeTextColor: Colors.white,
                                )
                                //    Text(model.giftorderList[i].qty.toString()),

                                ),
                          )
                        ],
                      ),
                    );
                  },
                ))
              ])
            : Container(),
      );
    });
  }
}
