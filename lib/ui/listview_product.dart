import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:flutter_crud/core/models/product.dart';
import 'package:flutter_crud/ui/product_information.dart';
import 'package:flutter_crud/ui/product_screen.dart';

class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

class _ListViewProductState extends State<ListViewProduct> {
  //de esta forma se crea una base de datos en fireBase
  final _productReference = FirebaseDatabase.instance.reference().child('product');
  List<Product> items;//todos los foturos productos

  //estos supongos que se eran eventos a la escucha de 
  //cuando se agrega y cuando se cambia un producto
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    //-------------------------------------------------------------------estas son funciones que seran las que avisen
    _onProductAddedSubscription = _productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription = _productReference.onChildChanged.listen(_onProductUpdated);
  }

  @override
  void dispose(){
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  void _onProductAdded( Event event){
    //cuando quiera crear un producto nuevo
    //simplemente lo agrego y lo convierto a algo que pueda manejar
    setState(() {
      items.add(new Product.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdated( Event event){
    //cuando quiera actualizar algun producto
    //saco el producto viejo, SOLO DONDE el id del producto sea igual al la llave del evento, que sera igual un ID!!
    var oldProduct = items.singleWhere((product)=>product.id== event.snapshot.key);
    //una vez teniendo el objeto que quiero actualizar
    //actualizo justo ese elemento por los nuevos datos
    setState(() {
      items[items.indexOf(oldProduct)] = new Product.fromSnapShot(event.snapshot);
    });
  }

  void _deleteProduct(BuildContext context,Product product, int i)async{
    //primero hago la peticion para borrarlo de la base de datos
    await _productReference.child(product.id).remove().then((_){
      //y luego (.then()) lo borro de mi lista de productos
      setState(() {
        items.removeAt(i);
      });
    });
  }

  void _naviagationToProduct(BuildContext context, Product product){
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>ProductScreen(product)
    ));
  }

void _editProduct(BuildContext context, Product product){
  Navigator.push(context, MaterialPageRoute(
    builder: (context)=>ProductInformation(product: product,)
  ));
}

void _addProduct(BuildContext context){
  Navigator.push(context, MaterialPageRoute(
    builder: (context)=> ProductScreen(Product())
  ));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.only(top: 12.0),
          itemBuilder: (context,i)=>Container(
            child: Column(
              children: <Widget>[
                Divider(height: 7.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text('${items[i].name}',style: TextStyle(color: Colors.blueAccent,fontSize: 21.0),),
                        subtitle: Text('${items[i].description}',style: TextStyle(color: Colors.blueGrey,fontSize: 21.0),),
                        leading: Column(
                          children: <Widget>[
                            CircleAvatar(//todo esto es una imagen con un numero que me indica, el numero que es
                              backgroundColor: Colors.orangeAccent,
                              radius: 17.0,
                              child: Text('${i+1}'),
                            ),
                          ],
                        ),
                        onTap: (){
                          _naviagationToProduct(context,items[i]);//TODO
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red,),
                            onPressed: ()=>_deleteProduct(context,items[i],i),
                          );
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue,),
                            onPressed: ()=>_editProduct(context,items[i]),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: ()=>_addProduct(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}