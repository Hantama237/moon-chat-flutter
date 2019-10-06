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

class ChatAct extends StatefulWidget{
  final String myuid;
  final String youruid;
  final DocumentSnapshot youruser;
  const ChatAct({@required this.myuid,@required this.youruid,@required this.youruser});
  ChatActState createState()=>ChatActState();
}
class ChatActState extends State<ChatAct>{
String myuid,youruid;
String yourToken;
DocumentSnapshot youruser;
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
  streamSub=getChatListener(myuid, youruid)
    .listen((snapshot){
      List<DocumentSnapshot> cht=[];
      snapshot.documents.forEach((i){
        if(i.data['sender_uid']==myuid&&i.data['receiver_uid']==youruid||i.data['sender_uid']==youruid&&i.data['receiver_uid']==myuid)
        cht.add(i);
      });
      if(!disposed){
        if(allowRead)
        readChat(myuid, youruid);
        readEachChat(cht,myuid);
      }
      setState(() {
       chats=cht; 
       isUploading=false;
      });
      futureScrolling(100);
      //getMessage();
    });
  else
  streamSub.resume();
}
sendImgMessage()async{
  setState(() {
   isUploading=true; 
  });
  bool uploaded=await uploadPhotoMessage(msg, youruid, myuid);
  if(!uploaded){
    setState(() {
     isUploading=false; 
    });
    return null;
  }
  createChatList(myuid, youruid, 'Picture');
  if(myUser==null||yourToken==null)
  await getMyUserAndUrToken();
  sendNotification(youruid, 'Sent a picture', myUser.data['name'],yourToken);
}
sendMessage()async{
  allowRead=false;
  addChat(msg, youruid, myuid);
  if(myUser==null||yourToken==null)
  await getMyUserAndUrToken();
  sendNotification(youruid, msg, myUser.data['name'],yourToken);
  await createChatList(myuid, youruid, msg);
  allowRead=true;
  readChat(myuid, youruid);
}
getMessage()async{
  List<DocumentSnapshot> cht=await getChats(myuid, youruid);
  setState(() {
   chats=cht; 
  });
  scrollController.animateTo(scrollController.position.maxScrollExtent,
  duration: Duration(milliseconds: 300), curve: Curves.ease);
}
getMyUserAndUrToken()async{
  myUser= await getMyProfile();
  yourToken=await getTokenByUid(widget.youruid);
}
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
    getMyUserAndUrToken();
    myuid=widget.myuid;
    youruid=widget.youruid;
    youruser=widget.youruser;
    createChatListener();
    Stream<String> fcmStream = fcm.onTokenRefresh;
    fcmStream.listen((token) {
      saveRefreshToken(token, myuid);
    });
    
    readChat(myuid, youruid);
    //delete this 
    print(myuid);
    print(youruid);
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
                            builder:(BuildContext context) => new ViewImage(url: youruser.data['display_img'],)
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
                        backgroundImage: CachedNetworkImageProvider(youruser.data['display_img']),
                      ),
                    ),
                  )
              ),
          Text(youruser.data['name'])
        ],),
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
                    if(!chats[index].data['content']){
                      return chatBubleRight(context, chats[index].data['msg'],chats[index].data['read'],date.toString().substring(11,16));
                    }else{
                      return contentBubleRight(
                        context, 
                        chats[index].data['msg'],
                        chats[index].data['read'],
                        date.toString().substring(11,16),
                        chats[index].data['content_url']
                        );
                    }
                  }else{
                    if(!chats[index].data['content']){
                      return chatBubleLeft(context, chats[index].data['msg'],date.toString().substring(11,16));
                    }else{
                      return contentBubleLeft(
                        context, 
                        chats[index].data['msg'],
                        date.toString().substring(11,16),
                        chats[index].data['content_url']
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