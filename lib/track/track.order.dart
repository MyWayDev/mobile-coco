import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/models/item.dart';

import 'package:n_gen/models/sales.order.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:n_gen/widgets/color_loader_2.dart';
import 'package:n_gen/widgets/custom_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class TrackOrder extends StatefulWidget {
  final String userId;

  TrackOrder(this.userId);
  @override
  State<StatefulWidget> createState() {
    return _TrackOrder();
  }
}

@override
class _TrackOrder extends State<TrackOrder> {
  List<Sorder> firstSorder;

  void isLoading(bool o, MainModel model) {
    setState(() {
      model.loadingSoPage = o;
    });
  }

  /* void _wait(String docId, String distrId) 
    Duration wait = Duration(milliseconds: 900);
    Timer(wait, () async {
      print('waiting....');
    });
    if (firstSorder.length > 0) {
      if (_checkDupl(docId, distrId)) {
        isLoading(false);
      } else {
        _wait(docId, distrId);
      }
    } else {
      _wait(docId, distrId);
    }
  }*/

  void _deleteSo(String docId, String distrId, MainModel model) async {
    model.distrIdDel = distrId;
    model.docIdDel = docId;
    isLoading(true, model);
    final http.Response responseI = await http.post(
        'http://mywayapi.azurewebsites.net/api/updatedelap/$docId/$distrId');

    if (responseI.statusCode == 200) {
      final http.Response responseII = await http.post(
          'http://mywayapi.azurewebsites.net/api/editvou/$docId/$distrId');
      if (responseII.statusCode == 200) {
        model.checkSoDupl(_getSorders, widget.userId);
      } else {
        isLoading(false, model);
        print('ERROR DELETE SO!');
      }
    } else {
      isLoading(false, model);
      print('ERROR UPDATE SO!');
    }
  }

  void _getSorders(String userId) async {
    firstSorder = [];
    final http.Response response = await http
        .get('http://mywayapi.azurewebsites.net/api/userpending/$userId');
    if (response.statusCode == 200 && firstSorder.length == 0) {
      print('getSorder ok');
      List<dynamic> soList = json.decode(response.body);
      List<Sorder> sos = soList.map((i) => Sorder.fromJson(i)).toList();
      List<SoItem> items = soList.map((i) => SoItem.fromJson(i)).toList();
//List<Invoice> firstInvoice = [];
//items.forEach((f)=>print('${f.itemId}..${f.docId}'));
      sos.forEach((f) => f.counter == '0001' ? firstSorder.add(f) : null);

      for (var i = 0; i < firstSorder.length; i++) {
        if (firstSorder[i].soItems == null) {
          firstSorder[i].soItems = [];
        }
      }
      for (SoItem item in items) {
        for (var i = 0; i < firstSorder.length; i++) {
          if (firstSorder[i].docId == item.docId) {
            firstSorder[i].soItems.add(item);
          } else {
            if (firstSorder[i].docId == item.docId) {
              firstSorder[i].soItems.add(item);
            }
          }
        }
      }
//firstInvoice.forEach((f)=>f.invoiceItems.forEach((f)=>print('${f.itemId}=>${f.price} * ${f.qty} = ${f.total}/${f.itemBp}==${f.totalBp}')));
//firstInvoice.forEach((f)=>print({f.docId:f.invoiceItems.length}));
//firstInvoice.forEach((f)=>print({f.docId:f.invocieTotal}));
    }
  }

  @override
  void initState() {
    _getSorders(widget.userId);
    super.initState();
  }

  Color _inlineColor(SoItem item) {
    Color _color = Colors.white;

    if (item.price == 0 && item.itemBp == 0) {
      _color = Colors.pink[50];
    } else if (item.price > 0 && item.itemBp > 0) {
      _color = Colors.grey[100];
    }

    return _color;
  }

  Future<int> getTimeDiff(MainModel model, int index) async {
    isLoading(true, model);
    DateTime orderTime = firstSorder[index].addDate;
    DateTime timeNow = await model.serverTimeNow();

    print('$orderTime=>$timeNow');
    Duration diff = timeNow.difference(orderTime);
    int timelapsed = diff.inMinutes;
    isLoading(false, model);
    return timelapsed;
  }

  void reBuildOrderFromLegacy(List<SoItem> items, MainModel model) {
    isLoading(true, model);
    model.giftorderList.clear();
    model.itemorderlist.clear();

    for (var i = 0; i < model.itemData.length; i++) {
      for (var d = 0; d < items.length; d++) {
        if (model.itemData[i].itemId == items[d].itemId && items[d].price > 0) {
          Item item = Item(
            itemId: items[d].itemId,
            price: model.itemData[i].price,
            bp: int.parse(model.itemData[i].bp.toString()),
            bv: model.itemData[i].bv,
            name: model.itemData[i].name,
            imageUrl: model.itemData[i].imageUrl,
          );
          model.addItemOrder(item, items[d].qty.toInt());
          //vitems.add(item);
        }
      }
    }
    print(model.itemorderlist.length);
    isLoading(false, model);
  }

  void _bottomSheetAlert(MainModel model, int wait) {
    showModalBottomSheet(
        context: context,
        builder: (buider) {
          return new Container(
            height: 80.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: new Text(
                      "    الرجاء الاتظار  ${(5 - wait)}  دقائق للتنفيذ "),
                )),
          );
        });
  }

  Widget _buildItem(SoItem item) {
    return item.price > 0 && item.totalBp == 0
        ? Container()
        : Card(
            color: _inlineColor(item),
            child: ListTile(
              leading: Text(
                item.itemId,
              ),
              title: Text(
                item.itemName,
              ),
              trailing: Text(item.qty.round().toString()),
            ),
          );
  }

  void _deleteSoDialog(List<SoItem> sOrder, String docId, String distrId,
      MainModel model, String title, bool edit) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          height: 80,
          child: AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              "$docId",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () {
                  if (!edit) {
                    _deleteSo(docId, distrId, model);
                    Navigator.of(context).pop();
                  } else {
                    reBuildOrderFromLegacy(sOrder, model);
                    _deleteSo(docId, distrId, model);
                    Navigator.of(context).pop();
                  }
                },
              ),
              // usually buttons at the bottom of the dialog
              new IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSorder(List<Sorder> sos, int index, MainModel model) {
    return ExpansionTile(
        backgroundColor:
            Colors.pink[300], // _statusColorDetails(sos[index].status),
        key: PageStorageKey<Sorder>(sos[index]),
        title: ListTile(
            leading: IconButton(
                disabledColor: Colors.transparent,
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () async {
                  int wait = await getTimeDiff(model, index);

                  if (wait > 5) {
                    _deleteSoDialog(
                        firstSorder[index].soItems,
                        sos[index].docId,
                        sos[index].distrId,
                        model,
                        " سيتم الغاء حجز المنتجات و مسح الطلبية رقم",
                        false);
                  } else {
                    _bottomSheetAlert(model, wait);
                  }
                }),
            title: Container(
              child: Column(
                children: <Widget>[
                  // Text(sos[index].docId, style: TextStyle(fontSize: 14)),
                  Text(
                    sos[index].distrName,
                    style: TextStyle(fontSize: 14),
                  ),
                  Divider(
                    height: 3.0,
                    indent: 0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            trailing: !model.cartLocked
                ? IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      int wait = await getTimeDiff(model, index);

                      if (wait > 5) {
                        _deleteSoDialog(
                            firstSorder[index].soItems,
                            sos[index].docId,
                            sos[index].distrId,
                            model,
                            " سيتم الغاء حجز المنتجات و التحويل الي سلة المشتريات للطلبية رقم",
                            true);
                      } else {
                        _bottomSheetAlert(model, wait);
                      }
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.block,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  )),
        children: sos[index].soItems.map(_buildItem).toList()
        //root.invoiceItems.map(_buildTiles).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 21.5,
            backgroundColor: Colors.transparent,
            //foregroundColor: Colors.transparent,
            onPressed: () {
              _getSorders(widget.userId);
            },
            child: Icon(
              Icons.refresh,
              size: 32,
              color: Colors.black38,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: ModalProgressHUD(
            inAsyncCall: model.loadingSoPage,
            opacity: 0.6,
            progressIndicator: LinearProgressIndicator(),
            child: Column(
              children: <Widget>[
                CustomAppBar("متابعة الطلبيات الغير المسددة"),
                Container(),
                Expanded(
                  child: ListView.builder(
                      itemCount: firstSorder.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8,
                          color: Colors.pink[700],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                //mainAxisSize: MainAxisSize.min,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey[400],
                                        size: 19,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Text(
                                        firstSorder[index].distrId,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            // fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey[400],
                                        size: 19,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Text(
                                        firstSorder[index].docDate,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            //fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[],
                              ),
                              ExpansionTile(
                                  backgroundColor: Colors.pink[400],
                                  key: PageStorageKey<Sorder>(
                                      firstSorder[index]),
                                  title: ListTile(
                                    leading: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(firstSorder[index].docId,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.yellow[100])),

                                          /*Text(firstSorder[index].distrId,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.yellow[100]))*/
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Dh ${firstSorder[index].soTotal}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[100],
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Bp ${firstSorder[index].soBp}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[100],
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  children: [
                                    _buildSorder(firstSorder, index, model)
                                  ]
                                  /* firstInvoice[index]
                        .invoiceItems
                        .map(_buildItem)
                        .toList()*/
                                  //root.invoiceItems.map(_buildTiles).toList(),
                                  ),
                            ],
                          ),
                        );
                        // EntryItem(invoices[index]);
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
