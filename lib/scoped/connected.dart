import 'package:n_gen/models/item.dart';
import 'package:n_gen/models/item.order.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

String _path = 'flamelink/environments/production/content/items';

class MainModel extends Model {
  // ** items //** */
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  String path = "flamelink/environments/production/content/items/en-US";
  List<Item> itemData = List();
  List<Item> searchResult = [];

  List<ItemOrder> itemorderlist = [];


void addItemOrder(Item item,int qty){
final ItemOrder itemorder = ItemOrder(
        itemId: item.itemId,
        price: double.parse(item.price.toString()),
        bp: item.bp,
        qty: qty);

if(item != null){
    itemorderlist.add(itemorder);
    notifyListeners();
    }
    else print('item ordered is null !!');
    print('itemId:${itemorder.itemId}--Price:${itemorder.price}*${itemorder.qty}=${itemorder.totalPrice}');
  print(itemorderlist.length);
}
//! working  here ... 
void updateItemOrder(index){
// itemorderlist.lastIndexWhere() =
}

List<ItemOrder> get displayItemOrder{
  return List.from(itemorderlist);
}

int itemCount(){
  int x = 0;
  for(ItemOrder i in itemorderlist){
    x+=i.qty;
  }
  print(x);
 return x;
}
    void displayOrder() {
      for (ItemOrder i in itemorderlist) {
        print('${i.itemId} : -- ${i.price} * ${i.qty} = ${i.totalPrice}');
        // itemorderlist.indexWhere((x) => x.itemId.contains(i.itemId));
      }
      print(itemorderlist.length);
    }

    onOrderChange(ItemOrder item) {
      var x = itemorderlist.indexOf(item);

      if (x == 0) {
        itemorderlist.replaceRange(
            int.parse(item.itemId), int.parse(item.itemId), [item]);
      } else {
        itemorderlist.add(item);
      }
      print(itemorderlist.length);
    }

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  void _onItemEntryAdded(Event event) {
    itemData.add(Item.fromSnapshot(event.snapshot));
  }

  void _onItemEntryChanged(Event event) {
    var oldEntry = itemData.lastWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    itemData[itemData.indexOf(oldEntry)] = 
    Item.fromSnapshot(event.snapshot);
  }

  void initItemSuper() {
    databaseReference = database.reference().child(path);
    databaseReference.onChildAdded.listen(_onItemEntryAdded);
    databaseReference.onChildChanged.listen(_onItemEntryChanged);
  }

  // **////////////////////////////////////////////////////////////////////////////////////////////////////////////////** */
  // **////////////////////////////////////////////////////////////////////////////////////////////////////////////////** */
  

  Future<bool> lockPage() async {
    bool lock;
    //Query query;
    String lockUrl =
        'https://mobile-coco.firebaseio.com/flamelink/environments/production/content/lockScreen/en-US/lockApp';
    database.reference().child(lockUrl).once().then((DataSnapshot snapshot) {
      lock = snapshot.value;
    });
    // print('lock Print$lock');
    return lock;
  }

  Future<bool> lockScreen() async {
    bool lock;
    String apiUrl =
        'https://mobile-coco.firebaseio.com/flamelink/environments/production/content/lockScreen/en-US/lockApp.json';
    http.Response response = await http.get(apiUrl);
    lock = json.decode(response.body);
    // print(json.decode(response.body));
    notifyListeners();
    return lock;
  }

  Future<User> fetchUser(String distrid) async {
    final response = await http
        .get('http://mywayapi.azurewebsites.net/api/memberid/$distrid');
    if (response.statusCode == 200) {
      print(User.formJson(json.decode(response.body)));
      return User.formJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user..');
    }
  }
//! working here !!!!!!!!!!!!...............

String _userDBPath = 'flamelink/environments/production/content/users/en-US';

 /*
  for( String key  in data.keys){
  if (key == id) {
       print('isDuplicatekey$key');
      print('isDuplicateid$id');
      ids.add(key);
      print(ids.length);
      }}
  
    print(ids.length);
   ids.length > 0? exists = true : exists =false;

   */




  void userPushToFirebase(String id User user ) {
   
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child
        (_userDBPath);       
    ref.child(id).set(user.toJson());

  }

  User memberData;
  Future<User> memberJson(String distrid) async {
    http.Response response = await http
        .get('http://mywayapi.azurewebsites.net/api/memberid/$distrid');
  
    if(response.body.length > 2){
    List responseData = json.decode(response.body);
    memberData = User.formJson(responseData[0]);
        }else
{
  return memberData = null;
}
    /*(
      distrId: responseData[0]['DISTR_ID'],
      name: responseData[0]['ANAME'],
      distrIdent: responseData[0]['DISTR_IDENT'],
      email: responseData[0]['E_MAIL'],
      phone: responseData[0]['TELEPHONE'],
    );*/
    return memberData;
  }

  Future<String> regUser(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // print(user.uid);
    return user.uid;
  }
 // bool isLoggedIn;
 /// bool isValid;
  Future<bool> formEntry(bool validate, Future<bool> signin) async {
    bool isLoggedIn = await signin;
    bool isValid = validate;
    print('isLoggedIn:$isLoggedIn');
    print('isValidIn:$isValid');
    if (isValid && isLoggedIn && loggedUser() != null) {
      return true;
    }
    return false;
  }


  Future<User> userData(String key) async {   
  DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child(_userDBPath).child(key)
        .once();
        User user = User.fromSnapshot(snapshot);
        return user;
}

FirebaseUser _user; 
  Future<bool> logIn(String key, String password) async {
  
  User _userInfo = await userData(key)
                      .catchError(
                          (e)=>print('ShitTY Erro:${e.toString()}')
                          );
    try {
      _user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _userInfo.email, password: password);
      print(' Future signIn display ${_user.uid}');
    } catch (e) {
      print('singin error caught:${e.toString()}');
      return false;
    }
    return true;

  }

  Future<bool> emailSignIn(String email, String password) async {
    try {
      _user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
            
      print(' Future signIn display ${_user.uid}');
    } catch (e) {
      print('singin error caught:${e.toString()}');
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    print('signing outttttttttt');
    return FirebaseAuth.instance.signOut();
  }

  Future<String> loggedUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.email;
  }
}

/* //! 
void main() async {
  List _data = await getJson();

  for (int i = 0; i < _data.length; i++) {}

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('JSON PARSE'),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      body: ListView.builder(
        itemCount: _data.length,
        padding: EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(_data[index]['ITEM_ID']),
                  Text(_data[index]['ANAME']),
                ],
              )
            ],
          );
        },
      ),
    ),
  ));
}

Future<List> getJson() async {
  String apiUrl = 'http://mywayapi.azurewebsites.net/api/allitemdetails';

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

*/
