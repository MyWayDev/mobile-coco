import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/models/gift_pack.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class GiftCard extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _GiftCard();
  }

  final List<GiftPack> giftData;
  final int index;

  GiftCard(this.giftData, this.index);
}

@override
class _GiftCard extends State<GiftCard> {
  @override
  void initState() {
    super.initState();
  }

  bool _isloading = true;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Stack(
        children: <Widget>[
          Positioned(
            child: Opacity(
              opacity: 1,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(
                  widget.giftData[widget.index].imageUrl,
                ),
                child: IconButton(
                  splashColor: Colors.purple,
                  icon: Icon(Icons.card_giftcard, size: 0.0),
                  onPressed: () {
                    model.loadGift(widget.giftData, widget.index);

                    /*
                    model.addGiftOrder(giftData[index]);
                    await model.checkGift(model.orderBp(), model.giftBp());
                    model.getGiftPack();*/
                  },
                ), //
              ),
            ),
          ),
          Text(
            widget.giftData[widget.index].bp.toString(),
            style: TextStyle(
                decorationColor: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.red),
          ),
        ],
      );
    });
  }
}
