import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:n_gen/account/accout_tabs.dart';
import 'package:n_gen/account/report.dart';
import 'package:n_gen/pages/items/items.dart';
import 'package:n_gen/pages/items/items.tabs.dart';
import 'package:n_gen/pages/order/order.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/track/track.tabs.dart';
import 'package:scoped_model/scoped_model.dart';

class BottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNav();
  }
}

// SingleTickerProviderStateMixin is used for animation
class _BottomNav extends State<BottomNav> with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController tabController;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        // Appbar
        /*appBar: new AppBar(
        // Title
        title: new Text("Using Bottom Navigation Bar"),
        // Set the background color of the App Bar
        backgroundColor: Colors.blue,
      ),*/
        // Set the TabBar view as the body of the Scaffold
        body: TabBarView(
          // Add tabs as widgets
          children: <Widget>[
            ItemsTabs(),
            AccountTabs(),
            Report(model.user.distrId),
          ],
          // set the controller
          controller: tabController,
        ),
        // Set the bottom navigation bar
        bottomNavigationBar: Material(
          // set the color of the bottom navigation bar
          color: Colors.transparent,
          elevation: 20,

          // set the tab bar as the child of bottom navigation bar
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            indicatorColor: Colors.pink[700],
            tabs: <Tab>[
              Tab(
                // set icon to the tab
                icon: Icon(
                  Icons.format_list_numbered,
                  size: 32,
                  color: Colors.pink[700],
                ),
              ),
              /*Tab(
                icon: Icon(Icons.notifications,
                    size: 32, color: Colors.pink[700]),
              ),*/
              Tab(
                icon: Icon(Icons.account_circle,
                    size: 32, color: Colors.pink[700]),
              ),
              Tab(
                icon: Icon(GroovinMaterialIcons.book_open,
                    size: 32, color: Colors.pink[700]),
              ),
            ],
            // setup the controller
            controller: tabController,
          ),
        ),
      );
    });
  }
}
