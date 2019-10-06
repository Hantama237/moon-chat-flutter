import 'package:flutter/material.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:moonchat/style/Colors.dart';

class Start extends StatefulWidget{
  StartState createState()=>StartState();
}
class StartState extends State<Start>{
  loginStateCheck() async{
      bool loggedIn = await checkLoginState();
      print(loggedIn);
      if (loggedIn){
        Navigator.of(context).pushReplacementNamed('/HomePage');
      }
    }
  @override
  Widget build(BuildContext context) {
    
    loginStateCheck();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Center(child:SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            createBigTitle('Welcome to MoonChat'),
            createLogoContaier(),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: createSimpleButton('Login', (){
                //loginStateCheck();
                //checkLoginState();
                Navigator.of(context).pushNamed("/LoginPage");
                
              })),
            Text("Don't have any account yet?",style: TextStyle(color: MyColor.accent),),
            Container(
              height: 20,
              child:createSimpleFlatButton('Register',onPressed: (){
                Navigator.of(context).pushNamed("/RegisterPage");
              },color: MyColor.accent))
          ],
        ),
      )
    )));
  }
}