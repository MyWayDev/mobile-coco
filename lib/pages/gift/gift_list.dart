import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/pages/gift/gift_card.dart';
import '../items/item.card.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class GiftList extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _GiftList();
  }
}

@override
class _GiftList extends State<GiftList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      // model.rungiftState();

      return Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ModalProgressHUD(
                color: Colors.transparent,
                inAsyncCall: model.isloading,
                opacity: 0.1,
                progressIndicator: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                ),
                child: model.giftPacks.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: model.giftPacks.length,
                        itemBuilder: (context, i) {
                          return GiftCard(model.giftPacks, i);
                        },
                      )
                    : Container(),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
    });
  }
}
