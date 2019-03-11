import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/models/item.dart';
import 'package:n_gen/models/item.order.dart';
import 'package:n_gen/models/lock.dart';
import 'package:n_gen/pages/user/lock_screen.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';

class SaveDialog extends StatefulWidget {
  final String courierId;
  final int courierFee;
  final String distrId;
  final String note;
  final String areaId;

  SaveDialog(
      this.courierId, this.courierFee, this.distrId, this.note, this.areaId);
  @override
  State<StatefulWidget> createState() {
    return _SaveDialog();
  }
}

@override
class _SaveDialog extends State<SaveDialog> {
  void initState() {
    super.initState();
  }

  bool _pending = false;

  void isLoading(bool o, MainModel model) {
    setState(() {
      model.loading = o;
    });
  }

  List<ItemOrder> getOrderList(MainModel model) {
    return model.itemorderlist.where((test) => test.bp != 0).toList();
  }

  bool pendingGift(MainModel model) {
    model.giftPacks.length > 0 ? _pending = true : _pending = false;
    setState(() {});
    return _pending;
  }

  @override
  Widget build(BuildContext context) {
    return _saveDialog(context);
  }

  Widget _saveDialog(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ModalProgressHUD(
        child: model.giftPacks.length == 0 && model.isBalanceChecked
            ? Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 475.0,
                  width: 310.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        color: Colors.grey[100],
                        child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'الكميه',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'كود',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: 300,
                        width: 275,
                        child: ListView.builder(
                          itemCount: getOrderList(model).length,
                          itemBuilder: (context, i) {
                            return orderCard(context, model, i);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RawMaterialButton(
                                    child: Icon(
                                      Icons.undo,
                                      size: 24.0,
                                      color: Colors.white,
                                    ),
                                    shape: CircleBorder(),
                                    highlightColor: Colors.pink[900],
                                    elevation: 3,
                                    fillColor: Colors.yellowAccent[700],
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    splashColor: Colors.pink[900],
                                  ),
                                  !model.loading
                                      ? RawMaterialButton(
                                          child: Icon(
                                            Icons.done_all,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          highlightColor: Colors.pink[900],
                                          elevation: 3,
                                          fillColor: Colors.green,
                                          onPressed: () async {
                                            isLoading(true, model);
                                            OrderMsg msg =
                                                await model.orderBalanceCheck(
                                                    widget.courierId,
                                                    widget.courierFee,
                                                    widget.distrId,
                                                    widget.note,
                                                    widget.areaId);
                                            if (model.orderBp() == 0 &&
                                                getOrderList(model).length ==
                                                    0) {
                                              Navigator.pop(context);
                                              isLoading(false, model);
                                              showReview(context, msg.soid,
                                                  msg.amt, msg.error);
                                            } else {
                                              isLoading(false, model);
                                            }
                                          },
                                          splashColor: Colors.pink[900],
                                        )
                                      : Container(),
                                ]),
                          )),
                    ],
                  ),
                ),
              )
            : Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 475.0,
                  width: 310.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        color: Colors.grey[100],
                        child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'الكميه',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'كود',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: 300,
                        width: 275,
                        child: ListView.builder(
                          itemCount: getOrderList(model).length,
                          itemBuilder: (context, i) {
                            return orderCard(context, model, i);
                          },
                        ),
                      ),
                      Container(
                          height: 120.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 1.0, right: 1.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'تم تحديث الطلبيه حسب الكميات المتاحه الان',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  RawMaterialButton(
                                    child: Icon(
                                      Icons.undo,
                                      size: 24.0,
                                      color: Colors.white,
                                    ),
                                    shape: CircleBorder(),
                                    highlightColor: Colors.pink[900],
                                    elevation: 3,
                                    fillColor: Colors.yellow[900],
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    splashColor: Colors.pink[900],
                                  ),
                                  Text(
                                    'الرجاء العوده للتعديل',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          )),
                    ],
                  ),
                ),
              ),
        inAsyncCall: model.loading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      );
    });
  }

  Future<bool> showReview(
      BuildContext context, String soid, double amt, String error) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 110.0,
              width: 110.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  soid != null || amt != 0 || soid != ''
                      ? Column(
                          children: <Widget>[
                            Text(
                              ' رقم الطلبيه: $soid ',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' قيمة الطلبيه: $amt ',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              '$error',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ],
                        ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/bottomnav', (_) => false);
                    },
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      color: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget orderCard(BuildContext context, MainModel model, int i) {
    return Container(
      height: 60,
      child: Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              getOrderList(model)[i].qty.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Center(
            child: Text(
              getOrderList(model)[i].itemId,
              style: TextStyle(color: Color(0xFFFF8C00)),
            ),
          ),
          trailing: CircleAvatar(
            backgroundColor: Colors.grey[100],
            backgroundImage: NetworkImage(
              getOrderList(model)[i].img,
            ),
          ),
        ),
      ),
    );
  }
}
