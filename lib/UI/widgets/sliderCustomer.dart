import 'dart:async';
import 'package:fashionstore/UI/widgets/ui_elements/logout_list_tile.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:fashionstore/core/services/Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


Widget BuildSideDrawerCustomer(BuildContext context) {
  return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(title: Text('Choose'), automaticallyImplyLeading: false, backgroundColor: Colors.red,),
      Divider(height: 2.0),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text('My Orders'),
          onTap: () async {
            var dbs = Api();
            var userid = await SharedPreferences.getInstance();
            await dbs.getOrdersForCustomer(userid.getInt('id'));
            new Timer.periodic(new Duration(seconds: 1), (timer) {
              //  print(dbs.dataOrder);
              model.setMyOrder(dbs.dataOrderCustomer);
              //  print(model.myOrder);
              if (dbs.dataOrderCustomer.length > 0) {
                timer.cancel();
              }
            });
            // dbs.getOrdersFC();

            Navigator.pushReplacementNamed(context, '/my-orders');
          }),
      Divider(height: 2.0),
      LogoutListTile(),
    ]));
  });
}
