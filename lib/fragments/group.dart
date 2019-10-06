import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/activity/create-group.dart';
import 'package:moonchat/activity/group-chat.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';
import 'package:moonchat/function/firebase-firestore.dart';

class Groups extends StatefulWidget{
  GroupState createState()=>GroupState();
}
class GroupState extends State<Groups>{
  String myuid;
  List<DocumentSnapshot> groups=[],friends=[];
  List<String> uidList=[];
  StreamSubscription<QuerySnapshot> streamSub;
  bool isLoading=true;
  setGroupListener()async{
    myuid=await getMyUid();
    if(streamSub==null)
    streamSub=(await getMyGroupListener(myuid)).listen((snapshot){
      setState(() {
        groups=snapshot.documents;
        isLoading=false;
      });
    });
    else{
    streamSub.resume();
    setState(() {
     isLoading=false; 
    });}
  }
  getFriends()async{
    List<DocumentSnapshot> res=await getUsers();
    setState(() {
     friends= res;
    });
    uidList=[];
    friends.forEach((i){
      uidList.add(i.data['id']);
    });
  }
  _showDialog(List<DocumentSnapshot> friends) async {
    TextEditingController name=new TextEditingController(),desc=new TextEditingController();
    List<String> member=[];
    await showDialog<String>(
      context: context,
      child: CreateGroup(friends: friends,myuid: myuid)
    );
  }

  
  @override
  void initState() {
    super.initState();
    setGroupListener();
    getFriends();
  }
  @override
  void dispose() {
    super.dispose();
     streamSub.pause();
  }
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Colony'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.accent,
        child: isLoading?CircularProgressIndicator():Icon(Icons.group_add),
        onPressed: isLoading?(){}:(){
          _showDialog(friends);
          //createGroup('Grup test','Test',['GE5EDNS8gZSLqM2dNSF0R4iq85I3','iHBZJnYospWjSvwnkvbyrzO4uRP2','vGXuycdBX2eK4q25wGZABzrBLFr1']);
        }),
      body: Container(
        child: ListView.separated(
          itemCount: groups.length,
          separatorBuilder: (contex,i){
            return Container();
          },
          itemBuilder: (context,index){
            return createGroupItem(context, 
            groups[index].data['group_name'],
            groups[index].data['member'].length.toString(), 
            groups[index].data['group_description'], 
            groups[index].data['group_picture'],
            onPressUpload: (){updateGroupPicture(groups[index].data['id']);},
            onPressEdit: (){
              //_showDialog(groups[index].data['group_name'], groups[index].data['group_description'],groups[index].data['id'],true);
              //todo add a firebase function
            },
            onPressChat: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(BuildContext context) => new GroupChatAct(users: friends,myuid: myuid,gid: groups[index],uidList:uidList,)
                )
              );
            }
            );
          },
        ),
      ),
    );
  }
}