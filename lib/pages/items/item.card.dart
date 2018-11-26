import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:n_gen/pages/items/item.details.dart';
import 'package:n_gen/models/item.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCard extends StatelessWidget {
  final List<Item> itemData;

  List<int> qtyList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final int index;
  ItemCard(this.itemData, this.index);
  ModelData _data = ModelData.empty();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFFFF1),
      elevation: 5.0,
      child: Column(children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                // color: Color.fromARGB(255, 66, 165, 245),
                //constraints: BoxConstraints.tight(Size(90, 100)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F${itemData[index].image[0].toString()}_${itemData[index].itemId}.png?alt=media&token=274fc65f-8295-43d5-909c-e2b174686439',
                      scale: 3.0,
                    ),
                    Positioned(
                      left: 3.0,
                      child: Opacity(
                          opacity: 0.72,
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F1540155801359_tag-50.png?alt=media',
                            scale: 1.0,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      ),
                      Text(
                        itemData[index].itemId,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFFFF8C00), //Colors.amber[900],
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      ),

                      Text(
                        itemData[index].name,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        itemData[index].size.toString() +
                            '  ' +
                            itemData[index].unit,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      ////////////////////////////////////////////////////////
                      ScopedModelDescendant<MainModel>(builder:
                          (BuildContext context, Widget child,
                              MainModel model) {
                        return Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ButtonBar(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.remove_shopping_cart),
                                      iconSize: 30.0,
                                      color: Colors.pink[600],
                                      onPressed: () {
                                        model.itemCount();
                                      },
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.info_outline),
                                        iconSize: 30.0,
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemDetails(
                                                          itemData[index])));
                                        }),
                                    //! working here....
                                    IconButton(
                                        icon: Icon(Icons.add_shopping_cart),
                                        iconSize: 30.0,
                                        color: Colors.pink[900],
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (_) => SimpleDialog(
                                                    title: Center(
                                                        child: Text('الكمية')),
                                                    children: <Widget>[
                                                      TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textAlign:
                                                            TextAlign.center,
                                                        onChanged: (value) {
                                                          _data.number =
                                                              int.parse(value);
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.check,
                                                          size: 40.0,
                                                          color: Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          if (_data.number !=
                                                              0) {
                                                            model.addItemOrder(
                                                                itemData[index],
                                                                _data.number);
                                                            Navigator.pop(
                                                                context);
                                                          } else
                                                            Navigator.pop(
                                                                context);
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                      }), //!here

                      Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'DRH ${itemData[index].price.toString()}',
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Bp ${itemData[index].bp.toString()}',
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
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
    );
  }
}

class ModelData {
  String text;
  int number;

  ModelData(this.text, this.number);

  ModelData.empty() {
    text = "";
    number = 0;
  }
}
