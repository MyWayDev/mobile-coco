import 'package:flutter/material.dart';
import 'package:n_gen/pages/items/items.dart';
import 'package:n_gen/pages/items/items.tabs.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/pages/welcome_page.dart';
import './pages/user/registration_page.dart';
import './pages/user/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/user/lock_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

//String _lockPath =
// 'https://epoch-1a552.firebaseio.com/flamelink/environments/production/content/lockScreen/en-US/lockApp';

//DatabaseReference databaseReference;
final FirebaseDatabase database = FirebaseDatabase.instance;
void main() {
  // final scoped.MainModel model = scoped.MainModel();
  // model.returnValue();
  // model.lockPage();
  /*final bool _lock = await model.lockScreen();
  if (_lock == true) {
    runApp(MyLock());
  } else*/

  //print(order);
  runApp(MyApp());
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWay Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        primaryColor: Colors.pink[900],
        accentColor: Colors.pinkAccent[700],
        backgroundColor: Colors.white70,
        buttonColor: Colors.pink[900],
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/registration': (BuildContext context) => RegistrationPage(),
      },
    );
  }
}*/
/*
class MyLock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyLock();
  }
}*/

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // databaseReference = database.reference().child(_lockPath);
    // databaseReference.onChildChanged.listen(_onlockChange);
  }

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'MyWay Mobile App',
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
          '/login': (BuildContext context) => LoginScreen(),
          '/registration': (BuildContext context) => RegistrationPage(),
          '/welcome': (BuildContext context) => Welcome(),
          //'/itemstabs': (BuildContext context) => ItemsTabs(),
          '/itemspage': (BuildContext context) => ItemsPage(),
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
/*
class _MyLock extends State<MyLock> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'MyWay Mobile App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: Colors.pink[900],
          accentColor: Colors.pinkAccent[700],
          backgroundColor: Colors.white70,
          buttonColor: Colors.pink[900],
        ),
        home: LockScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}*/

void _onlockChange(Event event) {
  event.snapshot.value;
}
