import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moonchat/activity/view-image.dart';
import 'package:moonchat/style/Colors.dart';


//===========================FORM===========================//
createSimpleTextInput( String hint,{bool secure=false,GlobalKey<FormFieldState> key,int maxLine=1,int maxLength,Function onSaved,Function onTap,TextEditingController controller}){

  return TextFormField(
    controller: controller,
    key: key,
    decoration: InputDecoration(
      hintText: hint,
    ),
    obscureText: secure,
    maxLines: maxLine,
    maxLength: maxLength,
    onSaved: onSaved,
    onTap: onTap,
  );
}

//==========================BUTTON==========================//
createSimpleButton(String title,Function onPressed){

  return RaisedButton(
    color: MyColor.primary,
    child: Text(title,style: TextStyle(color: Colors.white),),
    onPressed: onPressed,
  );
}
createSimpleFlatButton(String title,{Function onPressed,Color color}){

  return FlatButton(
    //color: color,
    child: Text(title,style: TextStyle(color: color==null?Colors.blue:color)),
    onPressed: onPressed,
  );
}

//========================TEXT================================//
createBigTitle(String title){
  return Text(
    title,
    style: TextStyle(color: MyColor.accent,fontSize: 28,fontWeight: FontWeight.bold),
  );
}

//============================IMAGE============================//
createLogoContaier(){
  return Container(
    width: 200,height: 200,
    child:Image.asset("assets/logo/moonchat.png")
    );
}

//=========================Friend item=========================//
createFriendItem(context,name,status,imageUrl){
  return Container(
    //color: Colors.red,
        padding: EdgeInsets.only(top: 10,left: 0,right: 10,bottom: 0),
        child: Container(//color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                                builder:(BuildContext context) => new ViewImage(url: imageUrl,)
                          )
                        );
                      },
                child: 
                Container(
                    //color: Colors.red,
                    padding: EdgeInsets.only(top: 0,left: 5,bottom: 5,right: 6),
                    child: Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: MyColor.brightPrimary,
                        backgroundImage: CachedNetworkImageProvider(imageUrl),
                      ),
                    ),
                  ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name,style: TextStyle(color: MyColor.accent,fontWeight: FontWeight.w600),),
                  Container(
                    width: MediaQuery.of(context).size.width-80,
                    child:Text(status,style: TextStyle(color: Colors.grey),)
                  )
                ],
              )
            ],
          ),
        )
      );
}
Widget createChatItem(BuildContext context,String name,String msg,Timestamp time,bool senderIsMe,int unreadCount,String imageUrl){
  //print(unreadCount);
  DateTime date,dateNow=DateTime.now();
    date=time==null?dateNow:time.toDate();
    int dayDistance=dateNow.day-date.day;
    String dateTime=dayDistance<1?date.toString().substring(11,16):dayDistance>=2?date.toString().substring(5,10):'Yesterday';
    return Container(
    //color: Colors.red,
        padding: EdgeInsets.only(top: 8,left: 0,right: 10,bottom: 0),
        child: Stack(children: <Widget>[
            Container(//color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  //color: Colors.red,
                  padding: EdgeInsets.only(top: 0,left: 5,bottom: 5,right: 6),
                  child: Center(
                    child: CircleAvatar(
                      radius: 29,
                      backgroundColor: MyColor.brightPrimary,
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    ),
                  ),
                ),
                
                // Container(
                //   width: 50,
                //   height: 50,
                //   child: Icon(Icons.account_circle,size: 50,),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name,style: TextStyle(color: MyColor.accent,fontWeight: FontWeight.w600,fontSize: 16),),
                    Container(height: 1,),
                    Container(
                      width: MediaQuery.of(context).size.width-90,
                      child:Text(msg!=null?msg:'',maxLines: 2,style: TextStyle(color: Colors.grey,fontWeight: senderIsMe?FontWeight.normal:unreadCount==0?FontWeight.normal:FontWeight.bold),)
                    )
                  ],
                )
              ],
            ),
          ),
          senderIsMe?Container():unreadCount==0?Container():Positioned(
            top: 20,
            right: 10,
            child: 
            Container(
              padding: EdgeInsets.all(4),
              child: Text(unreadCount.toString(),style: TextStyle(color: Colors.white,fontSize: 10),),
              decoration: BoxDecoration(
                color: MyColor.mooncloud,
                borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: Text(dateTime,style: TextStyle(
              color: Colors.grey,
              fontSize: 13
            ),),
          )
        ],)
      );
}

createGroupChatItem(BuildContext context,String name,String member,String msg,Timestamp time,bool senderIsMe,int unreadCount,String imageUrl){
  //print(unreadCount);
  DateTime date,dateNow=DateTime.now();
    date=time==null?dateNow:time.toDate();
    int dayDistance=dateNow.day-date.day;
    String dateTime=dayDistance<1?date.toString().substring(11,16):dayDistance>=2?date.toString().substring(5,10):'Yesterday';
    return Container(
    //color: Colors.red,
        padding: EdgeInsets.only(top: 7,left: 0,right: 10,bottom: 0),
        child: Stack(children: <Widget>[
            Container(//color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  //color: Colors.red,
                  padding: EdgeInsets.only(top: 0,left: 5,bottom: 5,right: 6),
                  child: Center(
                    child: CircleAvatar(
                      radius: 29,
                      backgroundColor: MyColor.brightPrimary,
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    ),
                  ),
                ),
                
                // Container(
                //   width: 50,
                //   height: 50,
                //   child: Icon(Icons.account_circle,size: 50,),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name+" ("+member+")",style: TextStyle(color: MyColor.accent,fontWeight: FontWeight.w600,fontSize: 16),),
                    Container(height: 1,),
                    Container(
                      width: MediaQuery.of(context).size.width-90,
                      child:Text(msg!=null?msg:'',maxLines: 2,style: TextStyle(color: Colors.grey,fontWeight: senderIsMe?FontWeight.normal:unreadCount==0?FontWeight.normal:FontWeight.bold),)
                    )
                  ],
                )
              ],
            ),
          ),
          senderIsMe?Container():unreadCount==0?Container():Positioned(
            top: 20,
            right: 10,
            child: 
            Container(
              padding: EdgeInsets.all(4),
              child: Text(unreadCount.toString(),style: TextStyle(color: Colors.white,fontSize: 10),),
              decoration: BoxDecoration(
                color: MyColor.mooncloud,
                borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: Text(dateTime,style: TextStyle(
              color: Colors.grey,
              fontSize: 13
            ),),
          )
        ],)
      );
}
//===============================Search Bar===================================//
createSearchBar(BuildContext context,{Function onPressed,Function onSaved,Function onChanged,GlobalKey key}){
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width-20,
          child:TextFormField(
            key: key,
            onSaved: onSaved,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: ' Search Friend',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: onPressed!=null?onPressed:(){},
              )
            ),
          )
        ),
      ],
    ),
  );
}

//=========================================================Profile================================================//
createProfilePicture(BuildContext context,String uri,Function onLongPress){
  return 
  InkWell(
    onLongPress: onLongPress,
    onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                    builder:(BuildContext context) => new ViewImage(url: uri,)
              )
            );
          },
    child: 
    Container(
              width: 130,
              height: 130,
              decoration: new BoxDecoration(
                border: Border.all(width: 3,color: MyColor.accent),
                shape: BoxShape.circle,
              ), child:
      Container(
              width: 130,
              height: 130,
              decoration: new BoxDecoration(
                border: Border.all(width: 3,color: Colors.yellow[100]),
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(uri)
                  )
              )
          )
      )
    );
}
createProfileInfo(context,snapshot,{Function onLongPressImg,Function onLongPressName,Function onLongPressStatus}){
  return Card(color: Colors.blueGrey[50],//grey[200],
            child: Column(
              children: <Widget>[
                Container(height: 30,),
                Center(
                  child: createProfilePicture(context,snapshot.data['display_img'],onLongPressImg)
                ),
                Container(height: 10,),
                InkWell(
                  onLongPress: onLongPressName,
                  child: Center(child: Text(snapshot.data['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: MyColor.accent))),
                ),
                Container(height: 10,),
                InkWell(
                  onLongPress: onLongPressStatus,
                  child: Container(
                    color: MyColor.accent,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child:Center(
                    child: Text(snapshot.data['status'],style: TextStyle(color: Colors.yellow[100]),textAlign: TextAlign.center,))
                  ),
                ),
                //Container(height: 30,)
              ],
            )
          );
}
//============================================================ GROUPS ==================================================//
createUserList(context,name,imageUrl){
  return Container(
    //color: Colors.red,
        padding: EdgeInsets.only(top: 10,left: 0,right: 10,bottom: 5),
        child: Container(//color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                                builder:(BuildContext context) => new ViewImage(url: imageUrl,)
                          )
                        );
                      },
                child: 
                Container(
                    //color: Colors.red,
                    padding: EdgeInsets.only(top: 0,left: 5,bottom: 5,right: 6),
                    child: Center(
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: MyColor.brightPrimary,
                        backgroundImage: CachedNetworkImageProvider(imageUrl),
                      ),
                    ),
                  ),
              ),
              Center(child: 
                  Text(name,style: TextStyle(color: MyColor.accent,fontWeight: FontWeight.bold),),
                )
            ],
          ),
        )
      );
}
//
createGroupItem(context,String name,String member,String desc,String imageUrl,{Function onPressUpload,Function onPressEdit,Function onPressChat}){
  return Container(
    
    child: 
    Container(
      padding: EdgeInsets.all(10),
      child: 
      Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: MyColor.brightPrimary,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
                radius: 40,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: 
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: IconButton(
                    icon: Icon(Icons.file_upload,color: MyColor.accent,size: 25,),
                    onPressed: onPressUpload,
                  ),
                )
                
              ,)
            ],
          ),
          Container(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width-200,
                child: Text(name+" ("+member+")",maxLines: 2,style: TextStyle( fontWeight: FontWeight.w600,fontSize: 15))
              ),
              Text(desc, style: TextStyle(color: Colors.grey),),
            ],
          ),
          Expanded(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Colors.grey[100],
                  child: Text('Edit'),
                  onPressed: onPressEdit,
                ),
                FlatButton(
                  color: Colors.grey[100],
                  child: Text('Chat'),
                  onPressed: onPressChat,
                ),
              ],
            ),
          ),
          
          
          Container(height: 10,)
        ],
      ),
    )
  );
}