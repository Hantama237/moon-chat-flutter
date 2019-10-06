import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final databaseReference = Firestore.instance;

//========================================================================================================================//
//========================================================== FIRESTORE ===================================================//
//========================================================================================================================//

void createRecord() async {
  //databaseReference.enablePersistence(true);
  await databaseReference.collection("users")
      .document("1")
      .setData({
        'name': 'Handryan',
        'status': 'Persetan dengan kesan, ku tak butuh pujian'
      });

  DocumentReference ref = await databaseReference.collection("books")
      .add({
        'title': 'Flutter in Action',
        'description': 'Complete Programming Guide to learn Flutter'
      });
  print(ref.documentID);
}
void getData() {
  databaseReference
      .collection("books")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => print('${f.data}'));
  });
}
void updateData() {
  try {
    databaseReference
        .collection('books')
        .document('1')
        .updateData({'description': 'Head First Flutter'});
  } catch (e) {
    print(e.toString());
  }
}
void deleteData() {
  try {
    databaseReference
        .collection('books')
        .document('1')
        .delete();
  } catch (e) {
    print(e.toString());
  }
}

void getConectivity() async{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
  }
}

//============================================================================================================================//
//====================================================== AUTH FUNCTION =======================================================//
//============================================================================================================================//

final mAuth=FirebaseAuth.instance;

//------------------------Register------------------------//
Future<List> signUp(String email,String password) async {
  try{
    AuthResult result= await mAuth.createUserWithEmailAndPassword(email:email, password:password);
    return [true,'Register Success'];
  }catch(e){
    print(e.message);
    return [false,e.message];
  }
}
createUser(String name,String email) async{
  FirebaseUser user=await mAuth.currentUser();
  String uid=user.uid;
  await databaseReference.collection("users")
    .document(uid)
    .setData({
      'id':uid,
      'name': name,
      'status': 'I am Moon Alien that want to invading planet Earth',
      'display_img':'assets/logo/moonchat.png',
      'email':email
    });
}
getMyUid()async{
  return (await mAuth.currentUser()).uid;
}


//--------------------------Login---------------------------//
Future<List> signIn(String email,String password) async{
  try{
    AuthResult result = await mAuth.signInWithEmailAndPassword(email:email, password:password);
    return [true,'Login Success'];
  }catch(e){
    print(e.message);
    return [false,e.message];
  }
}

void signOut() async {
  await mAuth.signOut();
}

Future<bool> checkLoginState() async{
  FirebaseUser fUser=await mAuth.currentUser();
  if(fUser!=null){
    print('Already logged in');
    return true;
  }else{
    print('Not Logged in');
    return false;
  }
}
//Future <dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {  return Future<void>.value();}
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
   if (message.containsKey('data')) {
     // Handle data message
     final dynamic data = message['data'];
   }

   if (message.containsKey('notification')) {
     // Handle notification message
     final dynamic notification = message['notification'];
   }

   // Or do other work.
 }

FirebaseMessaging fcm=FirebaseMessaging();
void setListener() async{
  print('setting listener');
  try{
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }catch(e){
    print(e);
  }
  
  
}
saveRefreshToken(String token,myuid)async{
  print('Saving '+token);
  var tokens = databaseReference
          .collection('tokens')
          .document(myuid);
  await tokens.setData({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
}
saveDeviceToken() async {

    // Get the current user
    String uid = (await mAuth.currentUser()).uid;
    
    // Get the token for this device
    String fcmToken = await fcm.getToken();
    print(fcmToken);
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = databaseReference
          .collection('tokens')
          .document(uid);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
//========================================================================================================================================================================//
//================================================================ Send Notification Using FCM ===========================================================================//
//========================================================================================================================================================================//

Future<String> getTokenByUid(uid) async{
  String token;
  try{
  await databaseReference
      .collection("tokens")
      .document(uid)
      .get()
      .then(
        (e){
          print(e.data['token']);
          token=e.data['token'];
        }
      );
  }catch(e){print('Error saat load token=====================================');}
  return token;
}
const firebaseTokenAPIFCM='key=AIzaSyDbxxg1etdDN4ggAKZILq-ydHKX8_nzgXk';
  Future<bool> sendNotification(String uid,String message,String sender,String token) async {
  //final String token=await getTokenByUid(uid);
  //String tkn=await fcm.getToken();
  
  var tokens=token;
  print(token);
  print('sampe sini');
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "to": token,
    "collapse_key": "type_a",
    "priority":"high",
    "notification": {
      "title": sender,
      "body" : message
    },
    "sound": "default",
    "badge": "1"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': firebaseTokenAPIFCM
  };

  final response = await http.post(postUrl,
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    print(response.body);
    return true;
  } else {
    print(' CFM error');
    print(response.body);
    // on failure do sth
    return false;
  }
}

Future<bool> sendNotificationGroup(List tokens,String message,String sender) async {
  //final String token=await getTokenByUid(uid);
  //String tkn=await fcm.getToken();
  
  //var tokens=token;
  //print(token);
  print('sampe sini');
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "register_ids": tokens,
    "collapse_key": "type_a",
    "priority":"high",
    "notification": {
      "title": sender,
      "body" : message
    },
    "sound": "default",
    "badge": "1"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': firebaseTokenAPIFCM
  };

  final response = await http.post(postUrl,
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    print(response.body);
    return true;
  } else {
    print(' CFM error');
    print(response.body);
    // on failure do sth
    return false;
  }
}

