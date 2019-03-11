import 'package:firebase_database/firebase_database.dart';

class Lock {
  String id;
  bool lockApp;
  bool lockCart;
  String catCode;
  String version;
  int safetyStock;
  int maxOrder;
  int adminFee;
  String bannerUrl;

  Lock(
      {this.id,
      this.lockApp = false,
      this.catCode,
      this.version,
      this.adminFee,
      this.safetyStock,
      this.maxOrder});

  Lock.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['id'],
        lockApp = snapshot.value['lockApp'],
        lockCart = snapshot.value['lockCart'],
        adminFee = snapshot.value['adminFee'],
        bannerUrl = snapshot.value['bannerUrl'],
        catCode = snapshot.value['catCode'],
        version = snapshot.value['version'],
        safetyStock = snapshot.value['safetyStock'],
        maxOrder = snapshot.value['maxOrder'];
}
