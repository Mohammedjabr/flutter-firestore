import 'package:fashionstore/UI/widgets/sliderSeller.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:fashionstore/UI/pages/product_create.dart';
import 'package:fashionstore/UI/pages/product_list.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('New Products'),
                backgroundColor: Colors.red,
                bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Add Product', icon: Icon(Icons.create)),
                      Tab(text: 'My Products', icon: Icon(Icons.list))
                    ])),
            drawer: BuildSideDrawerSeller(context),
            body: TabBarView(children: <Widget>[
              ProductCreatePage(),
              ProductListPage(model)
            ])));
  }
}
