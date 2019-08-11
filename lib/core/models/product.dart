import 'package:firebase_database/firebase_database.dart';

class Product {
String id;
String name;
String code;
String description;
String price;
String stock;

Product({this.id,this.name,this.code,this.description,this.price,this.stock});

String get getId =>id;
String get getName => name;
String get getCode => code;
String get getDescription => description;
String get getPrice => price;
String get getStock => stock;

  Product.map(dynamic json){
    this.name = json['name'];
    this.code = json['code'];
    this.description = json['description'];
    this.price = json['price'];
    this.stock = json['stock'];
}

  Product.fromSnapShot(DataSnapshot snapshot){//from json
    id = snapshot.key;
    name = snapshot.value['name'];
    code = snapshot.value['code'];
    description = snapshot.value['description'];
    price = snapshot.value['price'];
    stock = snapshot.value['stock'];
  }
}