import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/core/models/product.dart';

class ProductInformation extends StatefulWidget {
  final Product product;
  ProductInformation({this.product});

  @override
  _ProductInformationState createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  final _productReference = FirebaseDatabase.instance.reference().child('product');
  List<Product> items;

  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product information'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: 400,
        padding: EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("Name: ${widget.product.getName}", style: TextStyle(fontSize: 18.0),),
                Divider(height: 7.0,),
                Text("Description: ${widget.product.getDescription}", style: TextStyle(fontSize: 18.0),),
                Divider(height: 7.0,),
                Text("Code: ${widget.product.getCode}", style: TextStyle(fontSize: 18.0),),
                Divider(height: 7.0,),
                Text("Price: ${widget.product.getPrice}", style: TextStyle(fontSize: 18.0),),
                Divider(height: 7.0,),
                Text("Stock: ${widget.product.getStock}", style: TextStyle(fontSize: 18.0),),
                Divider(height: 7.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}