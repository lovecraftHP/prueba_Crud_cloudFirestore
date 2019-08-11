import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/ui/widgets/crud_buttons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  TextStyle _textButtonStyle = TextStyle(color: Colors.white);
  String _name;
  String _id;

  _buildFormField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Ingresa algo',
            filled: true,
            fillColor: Colors.grey[300],
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        style: TextStyle(color: Colors.blueAccent),
        validator: (value){
          if(value.isEmpty){
            return 'Ingresa algo!!';
          }
        },
        onSaved: (value){
          if(value.isNotEmpty){
            setState(() {
              _name = value;
            });
          }
        },
      ),
    );
  }


  Widget _buildItem(DocumentSnapshot docs) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${docs.data["name"]}',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              '${docs.data["todo"]}',
              style: TextStyle(fontSize: 21.0, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Text('Edit',style: _textButtonStyle,),
                    color: Colors.purple,
                    onPressed: ()=>_edit(docs),
                  ),
                RaisedButton(
                    child: Text('Delete',style: _textButtonStyle,),
                    color: Colors.red,
                    onPressed: ()=>_remove(docs),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  randomToDo() {
    final random = Random().nextInt(4);
    String todo;
    switch (random) {
      case 1:
        todo = 'Estudiar 2 horas';
        return todo;
      case 2:
        todo = 'Dibujar 2 horas';
        return todo;
      case 3:
        todo = 'Jugar 2 horas';
        return todo;
      default:
        todo = 'Hacer ejercicio 45min';
        return todo;
    }
  }

  void _create() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      DocumentReference ref= await db.collection('CRUD').add({'name':'$_name','todo':randomToDo()});
      setState(() {
        _id = ref.documentID;
      });
    }
    print('creado');
  }

  void _read()async{
    DocumentSnapshot snap= await db.collection('CRUD').document(_id).get();
    print(snap.data['name']);
    print('leido');
  }

  void _edit(DocumentSnapshot doc)async {
    await db.collection('CRUD').document(doc.documentID).updateData({'todo':'Haz cosas'});
    print('editado');
  }
  void _remove(DocumentSnapshot doc)async {
    await db.collection('CRUD').document(doc.documentID).delete();
    print('borrado');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba de CRUD'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: _buildFormField(),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Create',style: _textButtonStyle,),
                    color: Colors.green,
                    onPressed: ()=>_create(),
                  ),
                  RaisedButton(
                    child: Text('Read',style: _textButtonStyle,),
                    color: Colors.blue,
                    onPressed: ()=>_read(),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('CRUD').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents
                          .map((docs) => _buildItem(docs))
                          .toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
