import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:n_gen/pages/items/items.dart';
import 'package:n_gen/pages/order/order.dart';
import 'package:n_gen/pages/user/login_screen.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/track/track.order.dart';
import 'package:n_gen/track/track.tabs.dart';
import 'package:n_gen/widgets/switch_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:badges/badges.dart';

//////////////////////////////////////////////////////
///
///!notification badge over icon example code

class ItemsTabs extends StatelessWidget {
  ItemsTabs();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.userDetails();
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Drawer(
              child: Column(children: <Widget>[
            AppBar(
              title: Text('القائمه'),
            ),
            ListTile(
                leading: Icon(Icons.backspace),
                title: Text('خروج'),
                onTap: () {
                  model.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                }),
          ])),
          appBar: AppBar(
            ///////////////////////Top Tabs Navigation Widget//////////////////////////////
            title: TabBar(
              indicatorColor: Colors.grey[400],
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: <Widget>[
                Tab(
                  icon: new Icon(
                    Icons.format_list_numbered,
                    size: 29.0,
                    color: Colors.grey[350],
                  ),
                ),
                Tab(
                  child: BadgeIconButton(
                    itemCount: model.itemCount() < 0
                        ? 0
                        : model.itemCount(), // required
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey[350],
                      size: 29.0,
                    ), // required
                    //badgeColor: Colors.red, // default: Colors.red
                    badgeTextColor: Colors.white, // default: Colors.white
                    //hideZeroCount: true, // default: true
                  ),
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
                ),
                Tab(
                  icon: new Icon(
                    GroovinMaterialIcons.file_find,
                    size: 32.0,
                    color: Colors.grey[350],
                  ),
                ),
              ],
            ),
          ),
          ////////////////////////Bottom Tabs Navigation widget/////////////////////////
          body: TabBarView(
            children: <Widget>[
              ItemsPage(), // SwitchPage(ItemsPage()),
              OrderPage(), //SwitchPage(OrderPage()),
              TrackTabs(),
              //ProductList(),
            ],
          ),
          /* bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                  title: new Text('Account'),
                  icon: new Icon(Icons.account_box)),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.mail), title: new Text('Messages')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile'))
            ],
          ),*/
        ),
      );
    });
  }
/*new BottomNavigationBarItem(
        title: new Text('Home'),
        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.home),
            new Positioned(  // draw a red marble
              top: 0.0,
              right: 0.0,
              child: new Icon(Icons.brightness_1, size: 8.0, 
                color: Colors.redAccent),
            )
          ]
        ),
      )*/

  Widget _currentUser(BuildContext context, MainModel model) {
    return new FutureBuilder(
      future: model.loggedUser(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData)
          return Text(snapshot.data);
        else
          return Text('*');
      },
    );
  }
}
