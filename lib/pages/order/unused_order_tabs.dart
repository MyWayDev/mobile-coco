import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:n_gen/pages/gift/gift.dart';
import 'package:n_gen/pages/order/end_order.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/widgets/switch_page.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderTabs extends StatelessWidget {
  OrderTabs();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.rungiftState();
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            ///////////////////////Top Tabs Navigation Widget//////////////////////////////
            title: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.local_shipping,
                    size: 35.0,
                  ),
                ),
                Tab(
                    child: model.giftorderList.length > 0
                        ? BadgeIconButton(
                            itemCount: model.giftCount(),
                            // required
                            icon: Icon(
                              Icons.card_giftcard,
                              color: Colors.white,
                              size: 35.0,
                            ), // required
                            //badgeColor: Colors.red, // default: Colors.red
                            badgeTextColor:
                                Colors.white, // default: Colors.white
                            //hideZeroCount: true, // default: true
                          )
                        : Text('')
                    /* icon: new Stack(children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          size: 35.0,
                        ),
                        Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: )
                      ]),*/
                    )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              EndOrder(),
              GiftPage(),
              //ProductList(),
            ],
          ),
        ),
      );
    });
  }
}
