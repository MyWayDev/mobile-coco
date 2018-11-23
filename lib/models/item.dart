import 'package:firebase_database/firebase_database.dart';

class Item {
  String key;
  String itemId;
  String name;
  var price;
  var bp;
  var bv;
  List image;
  var size;
  String unit;
  String promo;
  List promoImage;
  bool catalogue;
  bool nw;
  bool disabled;
  bool discont;

  Item(
    this.key,
    this.itemId,
    this.name,
    this.price,
    this.bp,
    this.bv,
    this.image,
    this.size,
    this.unit,
    this.promo,
    this.promoImage,
    this.catalogue,
    this.nw,
    this.disabled,
    this.discont,
  );
  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        itemId = snapshot.value['itemId'],
        name = snapshot.value['name'],
        price = snapshot.value['price'],
        bp = snapshot.value['bp'],
        bv = snapshot.value['bv'],
        image = snapshot.value['image'],
        size = snapshot.value['size'],
        unit = snapshot.value['unit'],
        promo = snapshot.value['promo'],
        promoImage = snapshot.value['promoImage'],
        catalogue = snapshot.value['catalogue'],
        nw = snapshot.value['new'],
        disabled = snapshot.value['disabled'],
        discont = snapshot.value['discontinued'];
  toJson() {
    return {
      "key": key,
      "itemId": itemId,
      "name": name,
      "price": price,
      "bp": bp,
      "bv": bv,
      "image": image,
      "size": size,
      "unit": unit,
      "promo": promo,
      "promoImage": promoImage,
      "catalogue": catalogue,
      "new": nw,
      "disabled": disabled,
      "discontinued": discont,
    };
  }
}
