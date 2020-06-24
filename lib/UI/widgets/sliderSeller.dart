import 'dart:async';
import 'package:fashionstore/UI/widgets/ui_elements/logout_list_tile.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

Widget BuildSideDrawerSeller(BuildContext context) {
  return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    return Drawer(
        child: Column(children: <Widget>[

      AppBar(title: Text('Logout'), automaticallyImplyLeading: false,backgroundColor: Colors.red,),
      Divider(height: 2.0),
      LogoutListTile(),
    ]));
  });
}
