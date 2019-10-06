import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moonchat/activity/chat.dart';
import 'package:moonchat/activity/group-chat.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase-firestore.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';

class Chat extends StatefulWidget{
  ChatState createState()=>ChatState();
}
class ChatState extends State<Chat>{
  String myUid;
  bool disposed=false;
  bool isGroup=false;
  List <DocumentSnapshot>chatList,groupChatList,userList;
  List <String>uidList;
  StreamSubscription<QuerySnapshot> streamSub,groupStream,userStreamSub;

  createListener()async{
    if(myUid==null)
      myUid=await getMyUid();
    if(streamSub==null)
      streamSub=getChatList(myUid)
      .listen((snapshot){
        if(!disposed)
        setState(() {
          // assign to chat list
          chatList=snapshot.documents;
        });
        
      });
    else;
      //streamSub.resume();
    if(groupStream==null){
      groupStream=getMyGroupListener(myUid).listen((snapshot){
        if(!disposed)
        setState(() {
          // assign to chat list
          groupChatList=snapshot.documents;
        });
      });
    }

    if(userStreamSub==null)
      userStreamSub=getUserListener().listen((snapshot){
        userList=snapshot.documents;
        uidList=null;
        List<String> uids=[];
        userList.forEach((i){
          uids.add(i.data['id']);
        });
        if(!disposed)
        setState(() {
          // assign to userId list
          uidList=uids;
        });
      });
    else;
      //userStreamSub.resume();
  }
  @override
  void initState() {
    super.initState();
    if(!isGroup){
      createListener();
      setListener();
    }else{

    }
    disposed=false;
    
  }
  @override
  void dispose() {
    super.dispose();
    if(!isGroup){

    }else{

    }
    disposed=true;
    //streamSub.pause();
    //userStreamSub.pause();
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Chats'),
        actions: <Widget>[
          //Container(padding: EdgeInsets.only(right: 10),child:Center(child:Text(!isGroup?'Friends':'Colony')))
        ],
      ),
      
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MyColor.accent,
      //   child: !isGroup?Icon(Icons.person):Icon(Icons.group),
      //   onPressed: (){
      //     setState(() {
      //      isGroup=!isGroup; 
      //     });
      //   }),
      body: 
      chatList==null||groupChatList==null||uidList==null?Center(child: CircularProgressIndicator(),):
      Container(child:
        //padding: EdgeInsets.only(top: 10,left: 0,right: 10,bottom: 10),
        // child: chatList==null||groupChatList==null||uidList==null?Center(child: CircularProgressIndicator(),):
        // isGroup?
        Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              //color: MyColor.mooncloud,
              padding: EdgeInsets.all(10),
              child: Text('Colony Chats'+"("+groupChatList.length.toString()+")",style: TextStyle(color: MyColor.mooncloud, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              flex: 1,
              child: Container(
                constraints: new BoxConstraints(
                  minHeight: 100
                ),
                child: ListView.separated(
                itemCount: groupChatList.length,
                separatorBuilder: (context,index){
                  return SizedBox();
                  //return Container(margin: EdgeInsets.symmetric(horizontal: 10),width: MediaQuery.of(context).size.width-100,height: 2,color: MyColor.brightPrimary);
                },
                itemBuilder: (context,index){
                  int ind=(groupChatList.length-1)-index;
                  return groupChatList[ind].data['latest_msg']==null?Container():InkWell(
                    child: createGroupChatItem(
                      context,
                      groupChatList[ind].data['group_name'],
                      groupChatList[ind].data['member'].length.toString(),
                      groupChatList[ind].data['latest_msg'],
                      (groupChatList[ind].data['date_time'] as Timestamp),
                      (groupChatList[ind].data['read_list'].contains(myUid)),
                      groupChatList[ind].data['message_count'],
                      groupChatList[ind].data['group_picture']
                    ),
                    onTap: (){
                      Navigator.of(context).push(
                            MaterialPageRoute(
                                  builder:(BuildContext context) => new GroupChatAct(users: userList,myuid: myUid,gid: groupChatList[ind],uidList: uidList,)
                            )
                          );
                          readGroupChat(myUid, groupChatList[index].data['id']);
                      // Navigator.of(context).push(MaterialPageRoute(
                      // builder:(BuildContext context) => new ChatAct(myuid: myUid,youruid:chatList[index].data['chat_with_uid'],youruser: userList[(uidList.indexOf(chatList[index]['chat_with_uid']))],)
                      // ));
                    },
                  );
                },
              ),
        //:
        
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              //color: MyColor.mooncloud,
              padding: EdgeInsets.all(10),
              child: Text('Friend Chats'+"("+chatList.length.toString()+")",style: TextStyle(color: MyColor.mooncloud, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Container(child: 
                ListView.separated(
                  itemCount: chatList.length,
                  separatorBuilder: (context,index){
                    return SizedBox();
                    //return Container(margin: EdgeInsets.symmetric(horizontal: 10),width: MediaQuery.of(context).size.width-100,height: 2,color: MyColor.brightPrimary);
                  },
                  itemBuilder: (context,index){
                    
                    return InkWell(
                      child: createChatItem(
                        context,
                        userList[(uidList.indexOf(chatList[index]['chat_with_uid']))].data['name'],
                        chatList[index]['latest_msg'],
                        (chatList[index]['date_time'] as Timestamp),
                        myUid==chatList[index]['sender_uid'],
                        chatList[index]['unread_count'],
                        userList[(uidList.indexOf(chatList[index]['chat_with_uid']))].data['display_img']
                      ),
                      onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder:(BuildContext context) => new ChatAct(myuid: myUid,youruid:chatList[index].data['chat_with_uid'],youruser: userList[(uidList.indexOf(chatList[index]['chat_with_uid']))],)
                        ));
                      },
                    );
                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}