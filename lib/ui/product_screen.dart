import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/core/models/product.dart';

class ProductScreen extends StatefulWidget {

  final Product product;
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _producReference = FirebaseDatabase.instance.reference().child('product');
  List<Product> items;

  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _codeController;
  TextEditingController _descriptionController;
  TextEditingController _stockController;

  @override
  void initState() {
    _nameController = new TextEditingController(text:widget.product.getName);
    _priceController = new TextEditingController(text: widget.product.getPrice);
    _codeController = new TextEditingController(text: widget.product.getCode);
    _descriptionController = new TextEditingController(text: widget.product.getDescription);
    _stockController = new TextEditingController(text: widget.product.getStock);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,//esto es para los errores de barras amarrillas
      appBar: AppBar(
        title: Text('Product DB'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        height: 570,
        padding: EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 17.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Name'
                  ),
                ),
                SizedBox(height: 2.0,),
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 17.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Description'
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 2.0,),
                TextField(
                  controller: _codeController,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 17.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Code'
                  ),
                ),
                SizedBox(height: 2.0,),
                TextField(
                  controller: _priceController,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 17.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Price'
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 2.0,),
                TextField(
                  controller: _stockController,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 17.0),
                  decoration: InputDecoration(
                    icon: Icon(Icons.shop),
                    labelText: 'Stock'
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 2.0,),
                FlatButton(
                  onPressed: (){
                    if(widget.product.id==null){//si es vacio osea no existe, asi que lo crea
                      _producReference.child(widget.product.id).set({
                        'name':_nameController,
                        'description':_descriptionController,
                        'price': _priceController,
                        'code':_codeController,
                        'stock': _stockController
                      }).then((_){
                        Navigator.pop(context);
                      });
                    }else{//si existe que se actualice y listo
                      _producReference.push().set({
                        'name':_nameController,
                        'description':_descriptionController,
                        'price': _priceController,
                        'code':_codeController,
                        'stock': _stockController
                      }).then((_)=>Navigator.pop(context));
                    }
                  },
                  child: widget.product.id==null?Text('Add'):Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}