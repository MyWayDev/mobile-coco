import 'package:flutter/material.dart';
import 'package:n_gen/models/item.order.dart';
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
                                              context: context,
                                              builder: (_) => SimpleDialog(
                                                    title: Text('Qty'),
                                                    children: <Widget>[
                                                      TextField(
                                                        onChanged: (value) {},
                                                      )
                                                    ],
                                                  ));
                                          model.addItemOrder(itemData[index]);
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
