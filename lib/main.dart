

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_startup/flutter_startup.dart';
import 'package:moonchat/activity/chat.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/screen/home.dart';
import 'package:moonchat/screen/login.dart';
import 'package:moonchat/screen/register.dart';
import 'package:moonchat/screen/start.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:moonchat/style/Colors.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = FlutterIsolate.current.hashCode;
  
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}
runAlarmManager()async{
  final int helloAlarmID = 0;
   await AndroidAlarmManager.initialize();
   await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);
}
void isolate1(String arg) async  {

  //inal isolate = await FlutterIsolate.spawn(isolate2, "hello2");
  Timer.periodic(Duration(seconds:20),(timer)=>setListener());
}

main()  async{
  final isolate = await FlutterIsolate.spawn(isolate1, "hello");
  
  runApp(MyApp());
  
}
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    //setListener();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   //statusBarColor: Colors.blue[300]
    // ));
    
    return MaterialApp(
      title: 'Moon Chat',
      theme: ThemeData(
        primaryColor:MyColor.primary
      ),
      home: Start(),
      routes: <String, WidgetBuilder>{
        "/StartPage":(BuildContext context) => new Start(),
        "/LoginPage":(BuildContext context) => new Login(),
        "/RegisterPage":(BuildContext context) => new Register(),
        "/HomePage": (BuildContext context) => new Home(),

        "/ChatActivity":(BuildContext context) => new ChatAct()
      },
    );
  }
}