import 'package:flutter/material.dart';

import 'package:n_gen/models/courier.dart';
import 'package:n_gen/pages/gift/gift.dart';
import 'package:n_gen/pages/gift/gift_list.dart';
import 'package:n_gen/pages/order/widgets/order_save.dart';
import 'package:n_gen/pages/order/widgets/order_summary.dart';
import 'package:n_gen/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class CourierOrder extends StatefulWidget {
  final List<dynamic> couriers;
  final String areaId;
  final String distrId;

  CourierOrder(this.couriers, this.areaId, this.distrId);

  @override
  State<StatefulWidget> createState() {
    return _CourierOrder();
  }
}

@override
class _CourierOrder extends State<CourierOrder> {
  List<Courier> shipment = [];
  String areaId;
  Courier _chosenValue;
  Courier stateValue;
  int courierFee;
  void initState() {
    getinit();

    super.initState();
  }

  void getinit() async {
    shipment = widget.couriers;
    areaId = widget.areaId;
  }

  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        child: !model.loading
            ? Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 32,
                      child: TextField(
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                        controller: controller,
                        decoration: InputDecoration(
                          fillColor: Colors.lightBlue,
                          hintText: 'ملاحظات',
                        ),
                        // style: TextStyle(fontSize: 18.0),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),

                    model.giftorderList.length > 0
                        //|| model.giftPacks.length > 0
                        ? Text(
                            'هدايه النقاط',
                            style: TextStyle(
                                color: Colors.grey,
                                //fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.end,
                          )
                        : Container(),
                    model.giftPacks.length > 0
                        ? Row(
                            children: <Widget>[
                              Flexible(
                                child: SizedBox(
                                  height: 60.0,
                                  child: GiftList(),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    Row(
                      children: <Widget>[
                        model.giftorderList.length > 0
                            ? Expanded(
                                child: SizedBox(height: 120, child: GiftPage()),
                              )
                            : Container(),
                      ],
                    ),
                    model.giftPacks.length == 0
                        ? Container(
                            height: 55,
                            child: FormField<Courier>(
                              initialValue: _chosenValue = null,
                              onSaved: (val) => _chosenValue = val,
                              validator: (val) => (val == null)
                                  ? 'Please choose a Courier'
                                  : null,
                              builder: (FormFieldState<Courier> state) {
                                return InputDecorator(
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.local_shipping),
                                    labelText: stateValue == null
                                        ? 'طريقة الاستيلام'
                                        : '',
                                    errorText:
                                        state.hasError ? state.errorText : null,
                                  ),
                                  isEmpty: state.value == null,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Courier>(
                                      // iconSize: 25.0,
                                      // elevation: 5,
                                      value: stateValue,
                                      isDense: true,
                                      onChanged: (Courier newValue) async {
                                        if (newValue.courierId == '') {
                                          newValue = null;
                                        }
                                        setState(() {
                                          stateValue = newValue;
                                        });

                                        state.didChange(newValue);
                                        courierFee =
                                            await model.courierServiceFee(
                                                newValue.courierId,
                                                areaId,
                                                model.orderBp());
                                        print('courierFees$courierFee');
                                        print(areaId);

                                        print(newValue.courierId);
                                      },
                                      items: shipment.map((Courier courier) {
                                        return DropdownMenuItem<Courier>(
                                          value: courier,
                                          child: Text(
                                            courier.name,
                                            style: TextStyle(
                                                color: Colors.pink[900],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    Container(
                        height: 175,
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            stateValue != null && model.giftPacks.length == 0
                                ? OrderSummary(stateValue.courierId, courierFee,
                                    model.userInfo.distrId, controller.text)
                                : Container(),
                            courierFee != null &&
                                    model.orderBp() > 0 &&
                                    model.giftPacks.length == 0
                                ? OrderSave(
                                    stateValue.courierId,
                                    courierFee,
                                    widget.distrId,
                                    controller.text,
                                    widget.areaId)
                                : Container(),
                          ],
                        ))

                    //! missing widgets goes here;
                  ],
                ),
              )
            : Container(),
      );
    });
  }
}

/*     courierFee != null
                                      ? SingleChildScrollView(
                                          child: OrderSave(
                                              stateValue.courierId,
                                              courierFee,
                                              widget.distrId,
                                              controller.text,
                                              widget.areaId),
                                        )
                                      : Container(),*/
