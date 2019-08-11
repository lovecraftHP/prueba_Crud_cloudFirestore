import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id;
  final db = Firestore.instance;//instancia de la base de datos
  final _formKey = GlobalKey<FormState>();//llave del form
  String name;

  _buildForm(){
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Name',
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300]
      ),
      validator: (value){
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value){
        setState(() {
          name=value;
        });
      },
    );
  }
  String randomTodo(){
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
  Widget _buildBottons(){
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: createData,
            child: Text('Create',style: TextStyle(color: Colors.white),),
            color: Colors.green,
          ),
          RaisedButton(
            onPressed: id==null?readData:null,
            child: Text('Read',style: TextStyle(color: Colors.white),),
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  void createData() async{
    //si los datos del form son correctos
    if(_formKey.currentState.validate()){ 
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'name':'$name','todo':randomTodo()});
      setState(() {
        id=ref.documentID;
      });
      print(ref.documentID);
    }
  }

  void readData() async{
    //asi se lee
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

  Widget _buildItem(DocumentSnapshot doc){
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${doc.data["name"]}', style: TextStyle(fontSize: 24.0),),
            Text('${doc.data["todo"]}', style: TextStyle(fontSize: 20.0, color: Colors.grey),),
            SizedBox(height: 12.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: ()=>_update(doc),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: ()=>_delete(doc),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _update(DocumentSnapshot doc)async{
    //de esta forma se actualizan las cosas
    await db.collection('CRUD').document(doc.documentID).updateData({'todo':'cosas por hacer'});
    //la variable+la base de datos+ el id del documento+updateData con los datos
  }
  void _delete(DocumentSnapshot doc)async{
    //asi se borra
    await db.collection('CRUD').document(doc.documentID).delete();
    //mas reducido y no pregunta por nadie, pero ahora es necesario borrar el id de la variable
    setState(() {
      id= null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba CRUD'),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            Form(
              key: _formKey,
              child: _buildForm(),
            ),
            _buildBottons(),
            SizedBox(height: 2.0,),
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('CRUD').snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return Column(children:snapshot.data.documents.map((doc)=>_buildItem(doc)).toList(),);
                }else{
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}