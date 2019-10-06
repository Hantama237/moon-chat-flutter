import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/activity/chat.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase-firestore.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';

class Friend extends StatefulWidget{

  FriendState createState()=> FriendState();
}
class FriendState extends State<Friend>{
  bool showSearch =false;
  List<DocumentSnapshot> users;
  List<DocumentSnapshot> foundUser=[];
  final key = GlobalKey<FormFieldState>();
  String name='';
  bool showList=false;
  bool loaded=false;

  String myuid;

  var ref= Firestore.instance.collection('users');
  StreamSubscription<QuerySnapshot> streamSub;
            
  getListUser() async{
    users = await getUsers();
    myuid = await getMyUid();
    print(myuid);
    if(users!=null){
      setState(() {
       showList=true;
       loaded=true; 
      });
    }
  }

  searchUser(name){
    if(users!=null){
      List<DocumentSnapshot> found=[];
      for(int i=0;i<users.length;i++){
        if(users[i].data['name'].toString().toLowerCase().contains(name.toString().toLowerCase())){
          found.add(users[i]);
          print(i);
        }
      }
      setState(() {
        foundUser=found; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
      if(streamSub==null)
      streamSub=ref.snapshots().listen((snapshot){
        getListUser();
        print('There is change');
      });
      else if(streamSub.isPaused)
      streamSub.resume();
  }
  @override
  void dispose() {
    super.dispose();
    streamSub.pause();
  }

  @override
  Widget build(BuildContext context) {
    //if(!loaded)getListUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Fams'),
        actions: <Widget>[
          IconButton(icon: Icon(showSearch?Icons.cancel:Icons.search),
          onPressed: (){
            setState(() {
             showSearch=!showSearch; 
             searchUser('');
            });
          },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.accent,
        child: Icon(Icons.person_add),
        onPressed: (){
          getUsers();
        },),
      body: Column(
        children: <Widget>[
          showSearch?createSearchBar(
            context,
            key: key, 
            onSaved: (e){
              name=e;
            },
            onChanged: (e){
              key.currentState.save();
              searchUser(e);
            },
            onPressed: (){
              key.currentState.save();
              searchUser(name);
              print(name);
            }):Container(),
          Expanded(
            child: showList?Container(
              child: ListView.separated(
                    itemCount: showSearch?foundUser.length:users.length,
                    separatorBuilder: (context,index){
                      return Container();
                      // return myuid==(showSearch?foundUser[index].data['id']:users[index].data['id'])?
                      // Container()
                      // :Container(margin: EdgeInsets.symmetric(horizontal: 10),width: MediaQuery.of(context).size.width-100,height: 2,color: MyColor.brightPrimary);
                    },
                    itemBuilder: (context,index){
                      return myuid==(showSearch?foundUser[index].data['id']:users[index].data['id'])?
                      Container()
                      :
                      InkWell(
                        child: createFriendItem(
                          context,
                          showSearch?(foundUser[index].data['name']):(users[index].data['name']),
                          showSearch?(foundUser[index].data['status']):(users[index].data['status']),
                          showSearch?(foundUser[index].data['display_img']):(users[index].data['display_img'])
                        ),
                        onTap: (){Navigator.of(context).push(MaterialPageRoute(
                          builder:(BuildContext context) => new ChatAct(myuid: myuid,youruid: showSearch?foundUser[index].data['id']:users[index].data['id'],youruser: showSearch?foundUser[index]:users[index])
                          ));
                        },
                      );
                    },
                  )
            ):Center(child: CircularProgressIndicator(),)
          )
        ],
      )
    );
  }
}