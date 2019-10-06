import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/fragments/chats.dart';
import 'package:moonchat/fragments/friends.dart';
import 'package:moonchat/fragments/group.dart';
import 'package:moonchat/fragments/profile.dart';
import 'package:moonchat/style/Colors.dart';

class Home extends StatefulWidget{
  HomeState createState()=>HomeState();
}
class HomeState extends State<Home>{
  int selectedPage=0;
  final fragmentList=[
    Chat(),
    Friend(),
    Groups(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Moon Chat', textAlign:TextAlign.center),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: MyColor.darkb,
        type: BottomNavigationBarType.fixed,
        onTap: 
        (int index) {
          setState(() {
            selectedPage = index;
          });
        },
        currentIndex: selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.chat),
            title: Text('Chats')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.recent_actors),
            title: Text('Friends')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.group),
            title: Text('Groups')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: Text('Profile')
          )
        ],
      ),
      body: fragmentList[selectedPage],
    );
  }
}