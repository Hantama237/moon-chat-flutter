import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/activity/view-image.dart';
import 'package:moonchat/component/chat-components.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase-firestore.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';

class GroupChatAct extends StatefulWidget{
  final String myuid;
  final DocumentSnapshot gid;
  final List<DocumentSnapshot> users;
  final List<String> uidList;
  const GroupChatAct({@required this.myuid,@required this.gid,@required this.users,@required this.uidList});
  ChatActState createState()=>ChatActState();
}
class ChatActState extends State<GroupChatAct>{
String myuid,gid;
DocumentSnapshot group;
List<DocumentSnapshot> users;
List<String> uidList;
DocumentSnapshot myUser;
String msg;
final TextEditingController txtController= TextEditingController();
final key= GlobalKey<FormFieldState>();
StreamSubscription<QuerySnapshot> streamSub;
ScrollController scrollController = ScrollController();
DateTime date;
bool disposed=false;
bool isUploading=false;
bool allowRead=true;
List<DocumentSnapshot> chats;

createChatListener(){
  if(streamSub==null)
  streamSub=getGroupChatListener(gid).listen((snapshot){
    setState(() {
     chats=snapshot.documents; 
    });
    futureScrolling(100);
  });
  else
  streamSub.resume();
}
sendImgMessage()async{
  bool up=await uploadGroupPhotoMessage(gid, myuid);
  if(up)
  group.data['tokens'].forEach((i){
    sendNotification('','Someone '+'Sent a Picture',group.data['group_name'],i);
  });
  // sendNotification(youruid, 'Sent a picture', myUser.data['name'],yourToken);
}
sendMessage()async{
  addGroupChat(gid,msg,myuid,media: false);
  group.data['tokens'].forEach((i){
    sendNotification('','Someone: '+msg,group.data['group_name'],i);
  });
  // allowRead=false;
  // addChat(msg, youruid, myuid);
  // if(myUser==null||yourToken==null)
  // await getMyUserAndUrToken();
  // sendNotification(youruid, msg, myUser.data['name'],yourToken);
  // await createChatList(myuid, youruid, msg);
  // allowRead=true;
  // readChat(myuid, youruid);
}
// getMessage()async{
//   List<DocumentSnapshot> cht=await getChats(myuid, youruid);
//   setState(() {
//    chats=cht; 
//   });
//   scrollController.animateTo(scrollController.position.maxScrollExtent,
//   duration: Duration(milliseconds: 300), curve: Curves.ease);
// }
// getMyUserAndUrToken()async{
//   myUser= await getMyProfile();
//   yourToken=await getTokenByUid(widget.youruid);
// }
futureScrolling(int delay)async{
  await Future.delayed(Duration(milliseconds:delay));
  if(scrollController.hasClients){
    scrollController.animateTo(scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 100), curve: Curves.ease);
  }else{
    futureScrolling(100);
  }
}

  @override
  void initState() {
    super.initState();
    disposed=false;
    //getMyUserAndUrToken();
    myuid=widget.myuid;
    group=widget.gid;
    gid=widget.gid.data['id'];
    users=widget.users;
    uidList=widget.uidList;
    createChatListener();
    Stream<String> fcmStream = fcm.onTokenRefresh;
    fcmStream.listen((token) {
      saveRefreshToken(token, myuid);
    });
    
    // readChat(myuid, gid);
    // //delete this 
    // print(myuid);
    // print(gid);
  }
  @override
  void dispose() {
    super.dispose();
    streamSub.pause();
    disposed=true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: <Widget>[
          Container(
            width: 30,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          InkWell(
            onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                            builder:(BuildContext context) => new ViewImage(url: group.data['group_picture'],)
                      )
                    );
                  },
            child: 
            Container(
                    //color: Colors.red,
                    padding: EdgeInsets.only(top: 0,left: 5,bottom: 0,right: 8),
                    child: Center(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: MyColor.brightPrimary,
                        backgroundImage: CachedNetworkImageProvider(group.data['group_picture']),
                      ),
                    ),
                  )
              ),
            InkWell(
              onTap: (){
                //go to group member
              },
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(group.data['group_name']),
                  Text(group.data['member'].length.toString()+" members",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),)
                ],
              )
            )
        ],),

        actions: <Widget>[
         IconButton(icon: Icon(Icons.library_books),onPressed: (){},)
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child:Container(
              //color: Colors.red,
              child: chats==null?Center(child: CircularProgressIndicator(),):
              ListView.builder(
                
                controller: scrollController,
                //shrinkWrap: true,
                itemCount: chats.length,
                itemBuilder: (context,index){
                  
                  date=chats[index].data['date_time']!=null?chats[index].data['date_time'].toDate():DateTime.now();
                  if(chats[index].data['sender_uid']==myuid){
                    if(!chats[index].data['media']){
                      return chatGroupBubleRight(context, chats[index].data['msg'],false,date.toString().substring(11,16));
                    }else{
                      return contentGroupBubleRight(
                        context, 
                        chats[index].data['msg'],
                        false,
                        date.toString().substring(11,16),
                        chats[index].data['content_url']
                        );
                    }
                  }else{
                    int iOfUid=uidList.indexOf(chats[index].data['sender_uid']);
                    if(!chats[index].data['media']){
                      
                      return chatGroupBubleLeft(
                        context, 
                        chats[index].data['msg'],
                        date.toString().substring(11,16),
                        users[iOfUid].data['name'],
                        users[iOfUid].data['display_img']
                        );
                    }else{
                      return contentGroupBubleLeft(
                        context, 
                        chats[index].data['msg'],
                        date.toString().substring(11,16),
                        chats[index].data['content_url'],
                        users[iOfUid].data['name'],
                        users[iOfUid].data['display_img']
                        );
                    }
                  }  
                },
              ),
            )
          ),
          isUploading?Center(child: CircularProgressIndicator()):Container(),
          Container(
            height: 53,
            padding: EdgeInsets.only(bottom: 7),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: 
          
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(top: 0),
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.image,color: MyColor.accent,),
                    iconSize: 40,
                    onPressed: (){
                      sendImgMessage();
                    },
                  ),
                ),
                //input msg
                Container(
                  margin: EdgeInsets.only(left: 10),width: MediaQuery.of(context).size.width-105,
                  child: createSimpleTextInput('Enter message',
                  controller: txtController,
                  key: key,
                  onSaved: (e){
                    msg=e;
                  },
                  onTap: (){
                    futureScrolling(200);
                  }
                  ),
                ),
                
                IconButton(icon: Icon(Icons.send,size: 40,color: MyColor.accent,),
                onPressed: (){
                  key.currentState.save();
                  sendMessage();
                  txtController.clear();
                },),
                
              ],
            )
          )],
      ),
    );
  }
}