
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonchat/component/chat-components.dart';
import 'package:moonchat/function/firebase.dart';

final  reference= Firestore.instance;

//======================================= USER AND PROFILE ==========================================//
// GET THE LIST OF USER
Future <List<DocumentSnapshot>> getUsers() async{
  var users=await reference.collection('users').getDocuments();
  List<DocumentSnapshot> usersList=users.documents;
  print(usersList.length);
  return usersList;
}
// CREATE USER LISTENER
Stream<QuerySnapshot> getUserListener(){
  var streamSub=reference.collection('users')
  .snapshots();
  return streamSub;
}
// GET MY PROFILE
getMyProfile()async{
  String uid=await getMyUid();
  DocumentSnapshot snapshot=await reference.collection('users').document(uid).get();
  return snapshot;
}

//======================================= CHAT FUNCTION ==========================================//
// GET THE CONVERSATION
Stream<QuerySnapshot> getChatListener(String myUid,String yourUid){
  var streamSub= reference.collection('chats')
  .where('chat_room_users',arrayContains: myUid).orderBy('date_time')
  .snapshots();
  return streamSub;
}
// GET CHATS
Future<List<DocumentSnapshot>> getChats(myUid,yourUid)async{
  var res=await reference
  .collection('chats')
  .where('chat_room_users',arrayContains: myUid)
  .where('chat_room_users',arrayContains: yourUid)
  .orderBy('date_time').getDocuments();
  List<DocumentSnapshot> ourChats=[];
  ourChats=res.documents;
  readEachChat(ourChats, myUid);
  return ourChats;
}
readEachChat(List<DocumentSnapshot> chats,String myuid){
  List<String> unreadId=[];
  chats.forEach((i){
    if(i['read']==false&&i['receiver_uid']==myuid){
      unreadId.add(i.documentID);
    }
  });
  unreadId.forEach((i){
    reference
    .collection('chats')
    .document(i)
    .updateData({"read":true});
  });
}
// GET THE CHAT LIST
Stream<QuerySnapshot> getChatList(String myUid){
  var streamSub=reference.collection('chatlist')
  .document(myUid)
  .collection('chat_list')
  .orderBy('date_time',descending: true)
  .snapshots();
  return streamSub;
}
// CREATE CHAT LIST
createChatList(String myUid,String yourUid,String msg)async{
  //Get the unread counts
  DocumentSnapshot chat=await reference
      .collection("chatlist")
      .document(myUid)
      .collection('chat_list')
      .document(yourUid)
      .get();
  int unreadCount;
  if(chat.data!=null)
    unreadCount=chat.data['unread_count'];
  if(chat.data!=null)
    if(chat.data['sender_uid']==myUid){
      unreadCount=unreadCount+1;
    }else{
      unreadCount=1;
    }
  else
    unreadCount=1;
  print('creating mine ' +myUid);
  //Creating chatlist
  await reference.collection("chatlist")
      .document(myUid).collection('chat_list').document(yourUid)
      .setData({
        'latest_msg': msg,
        'unread_count': unreadCount,
        'sender_uid':myUid,
        'date_time':FieldValue.serverTimestamp(),
        'chat_with_uid':yourUid,
      },merge: true);
  print('creating yours ' +yourUid);
  await reference.collection("chatlist")
      .document(yourUid).collection('chat_list').document(myUid)
      .setData({
        'latest_msg': msg,
        'unread_count': unreadCount,
        'sender_uid':myUid,
        'date_time':FieldValue.serverTimestamp(),
        'chat_with_uid':myUid,
      },merge: true);
}
// send chat
Future addChat(String msg,String youruid, String myuid)async{
  print('sending chat');
  var res=reference.collection('chats');
  await res.add({
    'date_time':FieldValue.serverTimestamp(),
    'msg':msg,
    'read':false,
    'receiver_uid':youruid,
    'sender_uid':myuid,
    'chat_room_users':[myuid,youruid],
    'content':false,
    'content_url':'',
    'image':false
  });
  print('done');
  //return res.documentID;
}
Future readChat(myUid,yourUid)async{
  print('reading chatlist');
  DocumentSnapshot chat=await reference
      .collection("chatlist")
      .document(myUid)
      .collection('chat_list')
      .document(yourUid)
      .get();
  if(chat.data!=null)
  if(chat.data['sender_uid']!=myUid){
    await reference.collection("chatlist")
      .document(myUid).collection('chat_list').document(yourUid)
      .setData({
        //'latest_msg': msg,
        'unread_count': 0,
        //'sender_uid':myUid,
        //'date_time':FieldValue.serverTimestamp(),
        //'chat_with_uid':yourUid,
      },merge: true);
    await reference.collection("chatlist")
        .document(yourUid).collection('chat_list').document(myUid)
        .setData({
          //'latest_msg': msg,
          'unread_count': 0,
          //'sender_uid':myUid,
          //'date_time':FieldValue.serverTimestamp(),
          //'chat_with_uid':myUid,
        },merge: true);
    }
}

//======================================= UPDATE PROFILE ==========================================//
Future<String> pickImageCrop(String myuid,bool content)async{
  //pick img
  var img = await ImagePicker.pickImage(source: ImageSource.gallery);
  //crop
  if(img==null)return null;
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: img.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    if(croppedFile==null)return null;
    var readyUpload= await croppedFile.readAsBytes();
    //upload
    String fileName=await getContentCount(myuid);
    final StorageReference storageReference= 
      content?FirebaseStorage().ref().child('content').child(fileName):
      FirebaseStorage().ref().child('profile').child(fileName);
    final StorageUploadTask uploadTask = storageReference.putData(readyUpload);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });
    await uploadTask.onComplete;
    streamSubscription.cancel();
    //get url
    return (await storageReference.getDownloadURL()).toString();
}
Future updateProfileImage(String myuid)async{
  String imgUrl=await pickImageCrop(myuid,false);
  if(imgUrl!=null)
  await reference.collection('users').document(myuid).updateData({
    "display_img": imgUrl
  });
}
Future updateName(String myuid,String newName)async{
  await reference.collection('users').document(myuid).updateData({
    "name": newName
  });
}
Future updateStatus(String myuid,String newStatus)async{
  await reference.collection('users').document(myuid).updateData({
    "status": newStatus
  });
}

//======================================= UPLOAD CONTENT ==========================================//
Future<bool>uploadPhotoMessage(String msg,String youruid, String myuid)async{
  String imgUrl=await pickImageCrop(myuid,true);
  var res=reference.collection('chats');
  
  if(imgUrl==null)
  return false;
  await res.add({
    'date_time':FieldValue.serverTimestamp(),
    'msg':'',
    'read':false,
    'receiver_uid':youruid,
    'sender_uid':myuid,
    'chat_room_users':[myuid,youruid],
    'content':true,
    'content_url':imgUrl,
    'image':true
  });
  return true;
}
createContentCount(myuid)async{
  DocumentSnapshot counter=await reference.collection('media').document(myuid).collection('media_counter').document('counter').get();
  await reference.collection('media').document(myuid).collection('media_counter').document('counter').setData(
    counter.data==null?
    {
    "count":0
    }:
    {
    "count":counter.data['count']+1
    }
  );
}
Future<String> getContentCount(myuid)async{
  DocumentSnapshot counter=await reference.collection('media').document(myuid).collection('media_counter').document('counter').get();
  if(counter.data==null){
    await createContentCount(myuid);
    return (await getContentCount(myuid));
  }
    createContentCount(myuid);
    //print(counter.data['count']);
    return (myuid+'_no'+(counter.data['count']+1).toString());
}

//======================================= GROUPS ==========================================//
Future createGroup(String name,String desc,List<String> member)async{
  //gett counter to generate id
  DocumentSnapshot count= await reference.collection('groups').document('group_counter').collection('count').document('count').get();
  final String gid="group_"+(count.data['count']+1).toString();
  //creating group
  DocumentReference groupRef= reference.collection('groups')
  .document('group_list')
  .collection('list')
  .document(gid);
  groupRef.setData({
    "date_time":FieldValue.serverTimestamp(),
    "group_name":name,
    "group_description":desc,
    "group_picture":"",
    "id":gid,
    "member":member,
    "tokens":[],
    "latest_msg":null,
    "message_count":0,
    "read_list":[],
    "sender_uid":''
  });
  //increment the counter
  reference.collection('groups')
  .document('group_counter')
  .collection('count')
  .document('count')
  .setData({
    "count":count.data['count']+1
  });
  //obtaining token
  
    List<String> tokens=[];
    String token;
    for(int i=0;i<member.length;i++){
      token=await getTokenByUid(member[i]); 
      tokens.add(token);
      if(i==member.length-1)
      groupRef.updateData({
        "tokens":tokens
      });
      showToast("Done Creating group");
    }
  //setting token
}
//get my group list
Stream<QuerySnapshot> getMyGroupListener(String myuid){
  Stream<QuerySnapshot> groups=reference.collection('groups')
  .document('group_list')
  .collection('list')
  .where('member',arrayContains: myuid).orderBy("date_time")
  .snapshots();
  return groups;
}
//chat group add
addGroupChat(String gid,String msg,String myuid,{bool media,String url,String type})async{
  DocumentReference groupRef= reference.collection('groups')
  .document('group_list')
  .collection('list')
  .document(gid);
  groupRef.updateData({
    "latest_msg":msg,
    "message_count":1,
    "read_list":[myuid],
    "sender_uid":myuid,
    "date_time":FieldValue.serverTimestamp()
  });
  await reference.collection('groups')
  .document('group_chats')
  .collection('chats').add({
    "msg":msg,
    "content_url":url,
    "date_time":FieldValue.serverTimestamp(),
    "group_id":gid,
    "media":media,
    "read_by":[],
    "sender_uid":myuid,
    "type":type
  });
}
//chat listener
getGroupChatListener(String gid){
  var res=reference.collection('groups')
  .document('group_chats')
  .collection('chats')
  .where('group_id',isEqualTo:gid).orderBy('date_time')
  .snapshots();
  return res;
}
//add img chat
Future<bool>uploadGroupPhotoMessage(String gid, String myuid)async{
  String imgUrl=await pickImageCrop(myuid,true);
  //var res=reference.collection('chats');
  
  if(imgUrl==null)
  return false;
  await addGroupChat(gid, 'Picture', myuid,media: true,url: imgUrl,type: "image");
  return true;
}

readGroupChat(String myuid,String gid)async{
  DocumentReference groupRef= reference.collection('groups')
  .document('group_list')
  .collection('list')
  .document(gid);
  DocumentSnapshot res = await groupRef.get();
  List read=[];
  res.data['read_list'].forEach((i){
    read.add(i);
  });
  read.add(myuid);
  await groupRef.updateData({
    "read_list": read
  });
}
readEachGroupMessage(List<DocumentSnapshot> chats){
  chats.forEach((i){

  });
}

updateGroupPicture(String gid)async{
  String imgUrl=await pickImageCrop(gid,true);
  DocumentReference groupRef= reference.collection('groups')
  .document('group_list')
  .collection('list')
  .document(gid);
  if(imgUrl!=null){
    await groupRef.updateData({
      "group_picture": imgUrl
    });
    showToast("Done Uploading");
  }
}

updateGroupDetail(String gid,String name, String desc)async{
  DocumentReference groupRef= reference.collection('groups')
  .document('group_list')
  .collection('list')
  .document(gid);
  await groupRef.updateData({
    "group_name": name,
    "group_description":desc
  });
}