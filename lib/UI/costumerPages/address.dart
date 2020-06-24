import 'package:fashionstore/core/models/Address.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class Address extends StatefulWidget {
  //  final MainModel model;
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  int address_id;
  var selectRadioListTile = 0;

  void setRadioListTile(val) {
    setState(() {
      selectRadioListTile = val;
    });
  }

  List<Widget> createRadioListBotton(MainModel model) {
    // print(model.listAddress);
    List<Widget> widgets = [];
    for (AddressModel address in model.listAddress) {
      widgets.add(Container(
          margin: const EdgeInsets.only(top: 20),
          child: RadioListTile(
            value: address.address_id,
            groupValue: selectRadioListTile,
            title: Text(address.name),
            subtitle: Text(address.addressline),
            onChanged: (val) {
              address_id = val;
              setRadioListTile(val);
            },
          )));
      widgets.add(Divider(
        height: 20,
        color: Colors.black,
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text("Address"),
              backgroundColor: Colors.red,
            ),
            body: Column(
              children: createRadioListBotton(model),
            ),
            persistentFooterButtons: <Widget>[
              RaisedButton(
                      color: Colors.red,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/add-address'),
                      child: Text('Add New Address'),
                      textColor: Colors.white),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 1.7),
                child: RaisedButton(
                    onPressed: () {
                        model.addOrder(address_id);
                         Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Confirm'),
                    textColor: Colors.white),
              )
            ]);
      },
    );
  }
}

