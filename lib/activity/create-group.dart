import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/component/components.dart';
import 'package:moonchat/style/Colors.dart';
import 'package:moonchat/function/firebase-firestore.dart';

class CreateGroup extends StatefulWidget{
  final friends,myuid;
  const CreateGroup({@required this.friends,@required this.myuid});
  @override
  GroupState createState() {
    return GroupState();
  }
}
class GroupState extends State<CreateGroup>{
  TextEditingController name=new TextEditingController(),desc=new TextEditingController();
  //String myuid;
  List<String> member=[];
  List<DocumentSnapshot> friends=[];
  @override
  void initState() {
    friends=widget.friends;
    member.add(widget.myuid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Column(
          children: <Widget>[
            Text("Create new Colony",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            Container(height: 10,),
             new TextField(
               maxLength: 30,
                controller: name,
                autofocus: true,
                decoration: new InputDecoration(
                    hintText: 'Colony Name'),
              ),
            new TextField(
                maxLength: 30,
                controller: desc,
                autofocus: true,
                decoration: new InputDecoration(
                    hintText: 'Colony Description'),
            ),
            Container(height: 20,),
            Container(
              width: 400,
              padding: EdgeInsets.all(5),
              color: MyColor.accent,
              child: Text('Select Member',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Container(
                child: ListView.separated(
                  itemCount: friends.length,
                  separatorBuilder: (c,i){
                    return Container(height: 1,color: Colors. grey,);
                  },
                  itemBuilder: (c,i){

                    return Stack(children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            if(!member.contains(friends[i].data['id']))
                            member.add(friends[i].data['id']) ;
                            else
                            member.remove(friends[i].data['id']);
                          });
                        },
                        child: createUserList(context, friends[i].data['name'], friends[i].data['display_img']),
                      ),
                      member.contains(friends[i].data['id'])?
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(Icons.check,size: 20,),
                      ):Container()
                    ],);
                  },
                ),
              ),
            )
            
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Create'),
              onPressed: () {
                if(name.text.isNotEmpty && desc.text.isNotEmpty)
                createGroup(name.text,desc.text,member);
                Navigator.pop(context);
              })
        ],
      );
  }
}