import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/function/firebase.dart';
//Todo:displaying error message and loading,validator
class Register extends StatefulWidget{
  RegisterState createState()=>RegisterState();
}
class RegisterState extends State<Register>{
  final key = GlobalKey<FormState>();
  String name,email,password,confirmPassword;
  bool isLoading=false;

  Widget createRegister(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Build a Rocket'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(key: key,child:Column(
            children: <Widget>[
              createSimpleTextInput('Name',onSaved: (e){name=e;}),
              createSimpleTextInput('Email',onSaved: (e){email=e;}),
              createSimpleTextInput('Password',onSaved: (e){password=e;}),
              createSimpleTextInput('Confirm password',onSaved: (e){confirmPassword=e;}),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 40,
                child: createSimpleButton('Register', (){
                  setState(() {
                   isLoading=true; 
                  });
                  key.currentState.save();
                  register()async{
                    List result=await signUp(email, password);
                    if(result[0]){
                      await createUser(name, email);
                      await saveDeviceToken();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/HomePage');
                      setState(() {
                        isLoading=false; 
                      });
                    }else{
                      print(result[1]);
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
                  print('pressed');
                  register();
                }),
              )
            ],
          ),
        )
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: createRegister(),
      inAsyncCall: isLoading,
    );
  }
}