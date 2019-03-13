import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:n_gen/pages/items/icon_bar.dart';
import 'package:n_gen/widgets/color_loader_2.dart';
import 'package:n_gen/widgets/stock_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:n_gen/pages/items/item.details.dart';
import 'package:n_gen/models/item.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCard extends StatelessWidget {
  final List<Item> itemData;

  final int index;

  ItemCard(this.itemData, this.index);

  @override
  Widget build(BuildContext context) {
    return !itemData[index].disabled
        ? Card(
            color: Colors.white,
            // color: Color(0xFFFFFFF1),
            elevation: 20.0,
            child: Column(children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      // color: Color.fromARGB(255, 66, 165, 245),
                      //constraints: BoxConstraints.tight(Size(90, 100)),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          itemData[index].imageUrl != '' ||
                                  itemData[index].imageUrl != null
                              ? Image.network(
                                    itemData[index]
                                        .imageUrl, //'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F${itemData[index].image[0].toString()}_${itemData[index].itemId}.png?alt=media&token=274fc65f-8295-43d5-909c-e2b174686439',
                                    scale: 2.75,
                                  ) ??
                                  ''
                              : Container(),
                          Positioned(
                              left: 3.0,
                              child: Opacity(
                                opacity: 0.70,
                                child: itemData[index].promoImageUrl != "" ||
                                        itemData[index].promoImageUrl != null
                                    ? Image.network(
                                          itemData[index]
                                              .promoImageUrl, //  'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F1540155801359_tag-50.png?alt=media',
                                          scale: 1.1,
                                        ) ??
                                        ''
                                    : Container(),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                            ),
                            Text(
                              itemData[index].itemId,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFFFF8C00), //Colors.amber[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                            ),

                            Text(
                              itemData[index].name,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),

                            itemData[index].size != null ||
                                    itemData[index].unit != null
                                ? Text(
                                    itemData[index].size.toString() +
                                        '  ' +
                                        itemData[index].unit,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(''),

                            ////////////////////////////////////////////////////////
                            ScopedModelDescendant<MainModel>(builder:
                                (BuildContext context, Widget child,
                                    MainModel model) {
                              return Flex(
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconBar(itemData, index)
                                    ],
                                  ),
                                ],
                              );
                            }),

                            Flex(
                              direction: Axis.vertical,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'Dh ${itemData[index].price.toString()}',
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Bp ${itemData[index].bp.toString()}',
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
              ),
            ]),
          )
        : Container();
  }
}
