import 'dart:async';
import 'dart:convert';

import 'package:fashionstore/UI/widgets/sliderCustomer.dart';
import 'package:fashionstore/UI/widgets/sliderSeller.dart';
import 'package:fashionstore/core/models/category.dart';
import 'package:fashionstore/core/models/data.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:fashionstore/core/services/Api.dart';
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "package:fashionstore/UI/costumerPages/Cart.dart";
import "package:fashionstore/UI/costumerPages/Details.dart";

class Home extends StatefulWidget {
  MainModel appModel;
  static final String route = "Home-route";

  Home({this.appModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    
    widget.appModel.fetchLocalData();
    widget.appModel.fetchCategories();
    super.initState();
  }

  Widget merchantHome() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return
            Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () async{
                        await model.fetchCategeriesForAddProduct();
                        Navigator.pushNamed(context, '/admin');
                      },
                      child: Text(
                          'New Product', style: TextStyle(fontSize: 45)),
                      shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black),
                    ),),
                    SizedBox(height: 50,),
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async{
                        var dbs = Api();
                        var userid = await SharedPreferences.getInstance();
                        await dbs.getOrdersForSeller(userid.getInt('id'));
                        // model.setMyOrder(data);
                        new Timer.periodic(new Duration(seconds: 1), (timer) {
                          // print(dbs.dataOrderSeller);
                          model.setMyOrder(dbs.dataOrderSeller);
                          //  print(model.myOrder);
                          if (dbs.dataOrderSeller.length > 0) {
                            timer.cancel();
                          }
                        });
                        Navigator.pushNamed(context, '/orders');
                      },
                      child: Text('Orders',
                          style: TextStyle(fontSize: 45)),
                        shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),)
                  ],)
                ,
              ),
            );
        }
    );
  }



  Widget GridGenerate(List<Data> data, aspectRadtio) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: aspectRadtio),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(detail: data[index])));
                },
                child: Container(
                    height: 340.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          // BoxShadow(color: Colors.black12, blurRadius: 8.0)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 130.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Image.memory(
                                        base64Decode(
                                          data[index].image,
                                        ),
                                        fit: BoxFit.contain),

                                    // Image.network(data[index].image,fit: BoxFit.contain,),
                                  ),
                                ),
                                // Container(
                                //   child: data[index].fav ? Icon(Icons.favorite,size: 20.0,color: Colors.red,) : Icon(Icons.favorite_border,size: 20.0,),
                                // )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${data[index].title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "\$${data[index].price.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ));
        },
        itemCount: data.length,
      ),
    );
  }
  Widget categories(List<Category> cat) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cat.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                if (cat[index].id == 0) {
                  await model.fetchLocalData();
                } else {
                  await model.fetchProductByCategoryID(cat[index].id);
                }
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.only(top: 15.0, left: 5),
                child: Text(
                  "${cat[index].name}",
                  style: TextStyle(fontSize: 25),
                ),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12)
                    ]),
              ),
            );
          });
    });
  }


  Widget clientHome() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          var size = MediaQuery
              .of(context)
              .size;

          /*24 is for notification bar on Android*/
          final double itemHeight = (size.height - kToolbarHeight) / 2.5;
          final double itemWidth = size.width / 2;

          return Flexible(
              flex: 8,
              child: GridGenerate(model.itemListing, (itemWidth / itemHeight)));
        });}

  Widget Ink() {
   return  Stack(
     children: <Widget>[
       Padding(
         padding: EdgeInsets.all(10.0),
         child: InkResponse(
           onTap: () {
             widget.appModel.fetchCartList(widget.appModel.dataUser.getInt('id'));
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => Cart()));
           },
           child: Icon(Icons.shopping_cart),
         ),
       ),
     ],
   );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xffe9e9e9),
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.red,

        elevation: 0.0,
        actions: <Widget>[
         widget.appModel.dataUser.getInt('type') == 1 ? Text('') :Ink() ,
        ],
      ),


      drawer: widget.appModel.dataUser.getInt('type') == 1 ?  BuildSideDrawerSeller(context) : BuildSideDrawerCustomer(context),
      body:
       ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return Column(children: <Widget>[
          widget.appModel.dataUser.getInt('type') == 1 ?
          merchantHome() : clientHome(),
        ]);
      }),
    );
  }


}
