import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:n_gen/scoped/connected.dart';
import '../../models/user.dart';

class RegistrationPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _RegistrationPage();
  }
}

//final FirebaseDatabase dataBase = FirebaseDatabase.instance;

class _RegistrationPage extends State<RegistrationPage> {
  final model = MainModel();

  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  final Map<String, dynamic> _registrationFormData = {
    'email': null,
    'password': null,
    'userId': null,
    'PersonalId': null,
    'telephone': null
  };

  User _legacyData;

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

//!legacy distrid check for exists
  bool _legacyDataExits;
  bool legacyDataExists(User user) {
    if (user == null) {
      return _legacyDataExits = false;
    }

    return _legacyDataExits = true;
  }

  Future initlegacyData(String distrid) async {
    User user = await model.memberJson(distrid);
    legacyDataExists(user);

    setState(() {
      _legacyData = user;
      _legacyData.email = _registrationFormData['email'];
    });
  }

//!firebase distrid check for exists
  bool _fireDataExits;
  bool fireDataExists(User user) {
    if (user != null) return _fireDataExits = true;
    return _fireDataExits;
  }

  Future fireData(String distrId) async {
    User user = await model.userData(distrId).catchError((e) {
      if (e.toString().isNotEmpty) {
        _fireDataExits = false;
      }
    });
    print("error catch settiner:$_fireDataExits");
    fireDataExists(user);
  }

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  bool validateAndSave() {
    final form = _registrationFormKey.currentState;
    isloading(true);
    if (form.validate()) {
      // isloading(true);
      print('valide entry');
      _registrationFormKey.currentState.save();
      return true;
    }
    isloading(false);
    return false;
  }

  bool regCheck() {
    if (_registrationFormData['userId'] == _legacyData.distrId &&
        _registrationFormData['personalId'] == _legacyData.distrIdent) {
      print('regcheck:OK');
      return true;
    } else
      print('regcheck:not OK!!');
    return false;
  }

  void validateAndSubmit() async {
    if (regCheck()) {
      isloading(true);
      await model.regUser(
          _registrationFormData['email'], _registrationFormData['password']);
      model.userPushToFirebase(_legacyData.distrId, _legacyData);
      _registrationFormKey.currentState.reset();
      Navigator.pushNamed(context, '/login');
    } else {
      isloading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Registration Form'),
        ),
        body: ModalProgressHUD(
          child: Container(
            child: buildRegForm(context),
          ),
          inAsyncCall: _isloading,
          opacity: 0.6,
          progressIndicator: ColorLoader2(),
        ),
      );
    });
  }

  Widget buildRegForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage('assets/images/background.jpg'),
        ),
      ),
      child: Form(
        key: _registrationFormKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Myway Code',
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.vpn_key, color: Colors.pink[500])),
                      autocorrect: true,
                      autofocus: true,
                      autovalidate: true,
                      initialValue: '00000000',
                      validator: (value) {
                        if (value.length < 8 || value.length > 8) {
                          return 'length must be 8 digits';
                        }
                        String p = '[0-9]';
                        RegExp regex = new RegExp(p);
                        if (!regex.hasMatch(value)) {
                          return 'Invalid';
                        }
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        _registrationFormData['userId'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Personal ID',
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.assignment_ind,
                              color: Colors.pink[500])),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        _registrationFormData['personalId'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Telephone',
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.phone, color: Colors.pink[500])),
                      onSaved: (String value) {
                        _registrationFormData['telephone'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(
                            Icons.email,
                            color: Colors.pink[500],
                          )),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String value) {
                        _registrationFormData['email'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.pink[500],
                          )),
                      obscureText: true,
                      onSaved: (String value) {
                        _registrationFormData['password'] = value;
                      },
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton.icon(
                      label: Text('Test Code'),
                      icon: Icon(
                        Icons.playlist_add_check,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        _regPressed();
                      },
                    ),
                  ),
                  new Expanded(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      splashColor: Theme.of(context).primaryColor,
                      color: Colors.pink[100],
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Expanded(
                            child: Container(),
                          ),
                          new Transform.translate(
                            offset: Offset(15.0, 0.0),
                            child: new Container(
                              padding: const EdgeInsets.all(5.0),
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(28.0)),
                                splashColor: Colors.white,
                                color: Colors.white,
                                child: Icon(
                                  Icons.person_add,
                                  size: 32.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  _regPressed();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        _regPressed();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String errorM = '';

  void _regPressed() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (validateAndSave()) {
      await initlegacyData(_registrationFormData['userId'])
          .catchError((e) => '');
      await fireData(_registrationFormData['userId']).catchError((e) => '');
      if (!_legacyDataExits || _fireDataExits) {
        errorM = 'wrong code';
        print('legacyDataExits:$_legacyDataExits');
        print('fireDataExits:$_fireDataExits');
        isloading(false);
        print(errorM);
      } else {
        print('legacyDataExits:$_legacyDataExits');
        print('fireDataExits:$_fireDataExits');
        errorM = 'Good to GO';
        print(errorM);
        validateAndSubmit();
      }
    }
  }
}
