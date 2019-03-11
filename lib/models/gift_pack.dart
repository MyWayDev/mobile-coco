import 'package:n_gen/models/item.dart';

class GiftPack {
  String key;
  int bp;
  String desc;
  String imageUrl;
  List<Item> pack;

  int get qty {
    int _q;
    _q = 1;
    return _q;
  }

  GiftPack({this.key, this.bp, this.desc, this.imageUrl, this.pack});
}
