import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:flutter/material.dart';
import 'package:n_gen/pages/items/item.details.dart';
import 'package:n_gen/pages/order/order.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/item.dart';
import '../../models/order.dart';
import '../items/item.card.dart';
import 'package:n_gen/scoped/connected.dart';

class ItemsPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ItemsPage();
  }
}

@override
class _ItemsPage extends State<ItemsPage> {
  String path = "flamelink/environments/production/content/items/en-US";
  List<Item> itemData = List();
  List<Item> searchResult = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child(path);
    databaseReference.onChildAdded.listen(_onItemEntryAdded);
    databaseReference.onChildChanged.listen(_onItemEntryChanged);
  }

  String promoPic(int index) {
    String picStr =
        '${itemData[index].promoImage[0].toString()}_tag-${itemData[index].promo.toString().substring(2)}';
    String ok = 'ok';
    String no = 'no';
    if (itemData[index].promo.toString().substring(2) == 25.toString()) //||
      //itemData[index].promoImage.toString() != null)
      return 'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F1540155722221_tag-25.png?alt=media&token=be067db9-e0c4-4b92-a523-432f3bcd14e7';
    else
      return 'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F1540155801359_tag-50.png?alt=media&token=46fdc725-a01b-4674-a982-dbde43796078';
  }

  void add() {
    final Map<String, dynamic> data = {
      'a9master': {'CUS_VEN_ID': '00000001'},
      'apmaster': {"GROSS_TOTAL": 34.5, "NET_TOTAL": 34.5},
      'aadetail': [
        {"ITEM_ID": "8408", "QTY": 1}
      ],
      "aqdetail": [
        {
          "ITEM_ID": "8408",
          "QTY_REQ": 1,
          "UNIT_PRICE": 34.5,
          "NET_PRICE": 34.5,
          "TOT_PRICE": 34.5,
          "ITEM_BP": 18,
          "ITEM_BV": 35.88
        }
      ]
    };
    // http.post(orderUrl, body: json.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Card(
              child: ListTile(
                leading: Icon(
                  Icons.search,
                  size: 32.0,
                ),
                title: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  // style: TextStyle(fontSize: 18.0),
                  onChanged: onSearchTextChanged,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.cancel, size: 25.0),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
              child: searchResult.length != 0 || controller.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, i) {
                        return ItemCard(searchResult, i);
                      },
                    )
                  : FirebaseAnimatedList(
                      query: databaseReference,
                      itemBuilder: (_, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return ItemCard(itemData, index);
                      },
                    )),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    itemData.forEach((item) {
      if (item.name.contains(text) || item.itemId.contains(text))
        searchResult.add(item);
    });

    setState(() {});
  }

  void _onItemEntryAdded(Event event) {
    itemData.add(Item.fromSnapshot(event.snapshot));
  }

  void _onItemEntryChanged(Event event) {
    var oldEntry = itemData.lastWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    itemData[itemData.indexOf(oldEntry)] = Item.fromSnapshot(event.snapshot);
  }
}
