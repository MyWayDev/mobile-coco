import 'package:firebase_database/firebase_database.dart';

class Courier {
  String courierId;
  String name;
  List service;

  Courier({this.courierId, this.name, this.service});

  Courier.fromSnapshot(DataSnapshot snapshot)
      : courierId = snapshot.value['courierId'],
        name = snapshot.value['name'],
        service = snapshot.value['service'];

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(courierId: json['DS_SHIPMENT_COMP'], name: json['ANAME']);
  }
  factory Courier.fromList(Map<dynamic, dynamic> list) {
    return Courier(courierId: list['courierId'], name: list['name']);
  }
  toJson() {
    return {
      "courierId": courierId,
      "name": name + '1',
      "id": courierId,
    };
  }
}

class Service {
  String id;
  int fees;
  int freeBp;
  List areas;
  Service({this.id, this.fees, this.freeBp, this.areas});

  factory Service.fromJson(Map<dynamic, dynamic> json) {
    return Service(
      id: json['uniqueKey'],
      fees: json['fees'],
      freeBp: json['freeBp'],
      areas: json['areas'],
    );
  }
  toJson() {
    return {
      "fees": fees,
      "freeBP": freeBp,
      "areas": areas,
    };
  }

  Service.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['uniqueKey'],
        fees = snapshot.value['fees'],
        freeBp = snapshot.value['freeBp'],
        areas = snapshot.value['areas'];
}
