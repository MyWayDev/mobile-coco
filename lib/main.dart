import 'package:flutter/material.dart';
import 'package:n_gen/bottom_nav.dart';

import 'package:n_gen/pages/items/items.dart';
import 'package:n_gen/pages/items/items.tabs.dart';
import 'package:n_gen/pages/order/end_order.dart';
import 'package:n_gen/pages/order/order.dart';
import 'package:n_gen/pages/user/lock_screen.dart';

import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/pages/welcome_page.dart';
import 'package:n_gen/widgets/save_dialog.dart';
import 'package:n_gen/widgets/switch_page.dart';
import './pages/user/registration_page.dart';
import './pages/user/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {}
  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    model.settingsData();

    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'MyWay',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          //  const Locale('ar', 'MR'),
          const Locale('en', 'US'),
          const Locale('fr', 'FR'),
          // const Locale('ar', 'EG'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.pink,
          brightness: Brightness.light,
          primaryColor: Colors.pink[900],
          accentColor: Colors.pinkAccent[700],
          backgroundColor: Colors.white70,
          buttonColor: Colors.pink[900],
        ),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          //  '/':home,
          '/bottomnav': (BuildContext context) => BottomNav(),
          '/login': (BuildContext context) => LoginScreen(),
          '/registration': (BuildContext context) => RegistrationPage(),
          //'/welcome': (BuildContext context) => Welcome(),
          '/itemstabs': (BuildContext context) => ItemsTabs(),
          '/itemspage': (BuildContext context) => ItemsPage(),
          '/endorder': (BuildContext context) => EndOrder(),
          '/order': (BuildContext context) => OrderPage(),
          // '/savedialog':(BuildContext context) => SaveDialog(),
          //'/lockpage': (BuildContext context) => LockScreen(),
          // '/ordertabs': (BuildContext context) => OrderTabs(),
          // '/item':(BuildContext context) => ItemPage(),
        },
        /*
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'item') {
            final int index = int.parse(pathElements[2]);

            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ItemPage(index),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ItemsPage());
        },*/
      ),
    );
  }
}
