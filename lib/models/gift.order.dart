import 'package:n_gen/models/gift_pack.dart';
import 'package:n_gen/models/item.dart';

class GiftOrder {
  List<Item> pack;
  int bp;
  int qty;
  String imageUrl;
  String desc;

  GiftOrder({this.pack, this.bp, this.qty, this.imageUrl, this.desc});
}
