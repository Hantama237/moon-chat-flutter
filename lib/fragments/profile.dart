import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase-firestore.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';

import 'dart:typed_data';



class Profile extends StatefulWidget{
  ProfileState createState()=> ProfileState();
}
class ProfileState extends State<Profile>{
  bool loaded=false;
  bool show=false;
  bool disposed=false;
  DocumentSnapshot snapshot;

  var ref= Firestore.instance.collection('users');
  StreamSubscription<QuerySnapshot> streamSub;
  
  _showDialog(bool name) async {
    TextEditingController txt=new TextEditingController();
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: txt,
                autofocus: true,
                decoration: new InputDecoration(
                    hintText: name?'Enter Name':'Enter Status'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Save'),
              onPressed: () {
                name?updateName(snapshot.data['id'],txt.text):updateStatus(snapshot.data['id'],txt.text);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
  getData()async{
    snapshot=await getMyProfile();
    if(!disposed)
    setState(() {
     loaded=true;
     show=true; 
    });
  }
  @override
  void initState() {
    super.initState();
    if(streamSub==null)
    streamSub=ref.snapshots().listen((snapshot){
      getData();
    });
    else
    streamSub.resume();
    disposed=false;
  }
  @override
  void dispose() {
    super.dispose();
    streamSub.pause();
    disposed=true;
  }
  @override
  Widget build(BuildContext context) {
    //if(!loaded)getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Lord'),
        actions: <Widget>[
          createSimpleFlatButton('Sign Out',color: Colors.white,onPressed: (){
            mAuth.signOut();
            Navigator.of(context).pushReplacementNamed('/StartPage');
          })
        ],
        ),
      backgroundColor: MyColor.brightPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //show?createSimpleButton('title', (){ updateProfileImage(snapshot.data['id']);}):Container(),
          show?createProfileInfo(
            context,
            snapshot,
            onLongPressImg: (){updateProfileImage(snapshot.data['id']);},
            onLongPressName: (){_showDialog(true);},
            onLongPressStatus: (){_showDialog(false);}
            ):
          Center(heightFactor: 10,child:CircularProgressIndicator()),
        ],
      ),
    );
  }
}