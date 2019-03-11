import 'package:firebase_database/firebase_database.dart';
import 'package:n_gen/models/item.dart';

class Gift {
  List items;
  String desc;
  int bp;
  String imageUrl;

  Gift({this.items, this.bp, this.imageUrl, this.desc});

  Gift.fromSnapshot(DataSnapshot snapshot)
      : items = snapshot.value['items'],
        bp = snapshot.value['bp'];

  factory Gift.fromList(Map<dynamic, dynamic> list) {
    return Gift(
        bp: list['bp'],
        desc: list['desc'],
        items: list['items'],
        imageUrl: list['imageUrl']);
  }
}
