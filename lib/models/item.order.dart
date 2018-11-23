class ItemOrder {
  String itemId;
  double price;
  int bp;
  int qty;

  double get totalPrice {
    double _totalPrice = qty * price;
    return _totalPrice;
  }

  ItemOrder({
    this.itemId,
    this.price,
    this.qty,
    this.bp,
  }); //  this.bv, });
}
