import 'package:flutter/material.dart';

class CrudButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;

  CrudButton({this.title,this.color,this.onPress});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(title, style: TextStyle(color: Colors.white),),    
      color: color,
      onPressed: ()=>onPress(),//ojo con los parentesis
    );
  }
}