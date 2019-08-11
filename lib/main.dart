import 'package:flutter/material.dart';
import 'package:flutter_crud/home.dart';
//import 'package:flutter_crud/ui/listview_product.dart';

void main()=>runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}