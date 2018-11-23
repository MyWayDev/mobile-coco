import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class User {
  String key;
  String distrId;
  String name;
  String distrIdent;
  String email;
  String phone;
  bool isAllowed;

  User({
    this.distrId,
    this.email,
    this.distrIdent,
    this.phone,
    this.name,
  });

  /*
      'IsAllowed': true,
      'distrId': '00000005',
      'distrIdent': 'BK363612',
      'email': 'sabouauf@gmail.com',
      'id': '00000005',
      'isleader': false,
      'name': 'ali',
      'tele': '2443243',
  */
  toJson() {
    return {
      "IsAllowed": true,
      "distrId": distrId,
      "distrIdent": distrIdent,
      "email": email,
      "id": distrId,
      "isleader": false,
      "name": name,
      "tele": phone,
    };
  }

  factory User.formJson(Map<String, dynamic> json) {
    return User(
        distrId: json['DISTR_ID'],
        name: json['ANAME'],
        distrIdent: json['DISTR_IDENT'],
        email: json['E_MAIL'],
        phone: json['TELEPHONE']);
  }
  // * firebase sample code for model..
  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        distrId = snapshot.value["distrId"],
        email = snapshot.value["email"],
        isAllowed = snapshot.value["IsAllowed"];
}
