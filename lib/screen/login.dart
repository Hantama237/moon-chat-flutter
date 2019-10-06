import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//Todo:displaying error message and validator
class Login extends StatefulWidget{
  LoginState createState()=>LoginState();
}
class LoginState extends State<Login>{
  String email;
  String password;
  bool isLoading=false;
  final key1=GlobalKey<FormFieldState>();
  final key2=GlobalKey<FormFieldState>();

  Widget createLogin(){
    return Scaffold(
      appBar: AppBar(title: Text('Road to the Moon',textAlign: TextAlign.center)),
      body: Container(
        padding: EdgeInsets.all(10),
        child:Column(
          children: <Widget>[
            //FORM
            createSimpleTextInput('E-mail',key: key1,onSaved: (e){email=e;}),
            createSimpleTextInput('Password',key: key2,onSaved: (p){password=p;}),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 40,
              //BUTTON
              child: createSimpleButton('Login', (){
                setState(() {
                 isLoading=true; 
                });
                key1.currentState.save();
                key2.currentState.save();
                login()async{
                  List result=await signIn(email, password);
                  if(result[0]==true){
                    await saveDeviceToken();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed("/HomePage");
                    setState(() {
                      isLoading=false; 
                    });
                  }else{
                    print(result[1]);
                    //TOAST
                    Fluttertoast.showToast(
                        msg: result[1],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 12.0
                    );
                    setState(() {
                      isLoading=false; 
                    });
                  }
                }
                login();
              }),
            )
          ],
        )
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    //LOADING
    return ModalProgressHUD(
      child: createLogin(),
      inAsyncCall: isLoading
    );
  }
}