

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moonchat/activity/view-image.dart';
import 'package:moonchat/style/Colors.dart';
import 'package:url_launcher/url_launcher.dart';


showToast(msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12.0
  );
}
chatBubleRight(BuildContext context,String text,bool isRead,String time){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10,bottom: 5,top: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(isRead?'Read':' ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
                  InkWell(
                      onLongPress: (){
                        ClipboardManager.copyToClipBoard(text);
                        showToast('Text copied');
                      },
                      child: 
                  Container(
                    constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-50),
                    child: 
                    Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MyColor.mooncloud,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    child: 
                    Linkify(
                      text: text,
                      onOpen: (LinkableElement url){launch(url.url);},
                      style: TextStyle(color: Colors.white),
                      linkStyle: TextStyle(color: Colors.yellow[100]),
                    ),
                    //child:Text(text,style: TextStyle(color: Colors.white),)
                  ),
                )
              ),
            ],
          ),
        );
}
chatBubleLeft(BuildContext context,String text,String time){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  InkWell(
                    onLongPress: (){
                      ClipboardManager.copyToClipBoard(text);
                      showToast('Text copied');
                    },
                    child: 
                    Container(
                      constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-50),
                      child: 
                      Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      child: 
                      Linkify(
                        text: text,
                        onOpen: (LinkableElement url){launch(url.url);},
                        style: TextStyle(color: Colors.black),
                        //linkStyle: TextStyle(color: Colors.yellow[100]),
                      ),
                      //child:Text(text,style: TextStyle(color: Colors.black),)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(' ' ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
}

contentBubleRight(BuildContext context,String text,bool isRead,String time,String url){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width-70,
          margin: EdgeInsets.only(left: 20,bottom: 5,top: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(isRead?'Read':' ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
                  InkWell(
                      onLongPress: (){
                        ClipboardManager.copyToClipBoard(url);
                        showToast('Content url copied');
                      },
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                                builder:(BuildContext context) => new ViewImage(url: url,)
                          )
                        );
                      },
                      child: 
                  Container(
                    constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-100),
                    child: 
                    Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: MyColor.mooncloud,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    child: 
                    Column(children: <Widget>[
                      // Linkify(
                      //   text: text,
                      //   onOpen: (LinkableElement url){launch(url.url);},
                      //   style: TextStyle(color: Colors.white),
                      //   linkStyle: TextStyle(color: Colors.yellow[100]),
                      // ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(url)
                          )
                        ),
                      )
                    ],)
                    //child:Text(text,style: TextStyle(color: Colors.white),)
                  ),
                )
              ),
            ],
          ),
        );
}
contentBubleLeft(BuildContext context,String text,String time,String url){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width-70,
          margin: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  InkWell(
                    onLongPress: (){
                      ClipboardManager.copyToClipBoard(url);
                      showToast('Content url copied');
                    },
                    onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                                builder:(BuildContext context) => new ViewImage(url: url,)
                          )
                        );
                      },
                    child: 
                    Container(
                      constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-100),
                      child: 
                      Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      child: 
                      Column(children: <Widget>[
                      // Linkify(
                      //   text: text,
                      //   onOpen: (LinkableElement url){launch(url.url);},
                      //   style: TextStyle(color: Colors.black),
                      //   //linkStyle: TextStyle(color: Colors.yellow[100]),
                      // ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(url)
                          )
                        ),
                      )
                    ],)
                      //child:Text(text,style: TextStyle(color: Colors.black),)
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(' ' ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
}

chatGroupBubleRight(BuildContext context,String text,bool isRead,String time){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10,bottom: 5,top: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(isRead?'Read':' ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
                  InkWell(
                      onLongPress: (){
                        ClipboardManager.copyToClipBoard(text);
                        showToast('Text copied');
                      },
                      child: 
                  Container(
                    constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-50),
                    child: 
                    Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColor.mooncloud,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    child: 
                    Linkify(
                      text: text,
                      onOpen: (LinkableElement url){launch(url.url);},
                      style: TextStyle(color: Colors.white),
                      linkStyle: TextStyle(color: Colors.yellow[100]),
                    ),
                    //child:Text(text,style: TextStyle(color: Colors.white),)
                  ),
                )
              ),
            ],
          ),
        );
}
chatGroupBubleLeft(BuildContext context,String text,String time,String sender,String url){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width-60,
          margin: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(url),
                    backgroundColor: MyColor.mooncloud,
                  ),
                  Container(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(sender,style: TextStyle(color: MyColor.accent,fontSize: 11,fontWeight: FontWeight.bold),),
                      Container(height: 2,),
                      Row(
                        children: <Widget>[
                          InkWell(
                              onLongPress: (){
                                ClipboardManager.copyToClipBoard(text);
                                showToast('Text copied');
                              },
                              child: 
                              Container(
                                constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-100),
                                child: 
                                Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                ),
                                child: 
                                Linkify(
                                  text: text,
                                  onOpen: (LinkableElement url){launch(url.url);},
                                  style: TextStyle(color: Colors.black),
                                  //linkStyle: TextStyle(color: Colors.yellow[100]),
                                ),
                                //child:Text(text,style: TextStyle(color: Colors.black),)
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(time ,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                  ),
                                ),
                                Text(' ' ,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )
            ],
          ),
        );
}

contentGroupBubleRight(BuildContext context,String text,bool isRead,String time,String url){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width-70,
          margin: EdgeInsets.only(left: 20,bottom: 5,top: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(time ,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                      Text(isRead?'Read':' ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
                  InkWell(
                      onLongPress: (){
                        ClipboardManager.copyToClipBoard(url);
                        showToast('Content url copied');
                      },
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                                builder:(BuildContext context) => new ViewImage(url: url,)
                          )
                        );
                      },
                      child: 
                  Container(
                    constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-100),
                    child: 
                    Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: MyColor.mooncloud,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    child: 
                    Column(children: <Widget>[
                      // Linkify(
                      //   text: text,
                      //   onOpen: (LinkableElement url){launch(url.url);},
                      //   style: TextStyle(color: Colors.white),
                      //   linkStyle: TextStyle(color: Colors.yellow[100]),
                      // ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(url)
                          )
                        ),
                      )
                    ],)
                    //child:Text(text,style: TextStyle(color: Colors.white),)
                  ),
                )
              ),
            ],
          ),
        );
}
contentGroupBubleLeft(BuildContext context,String text,String time,String url,String sender,String imgUrl){
  return Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width-10,
          margin: EdgeInsets.only(left: 5,bottom: 5,top: 5,right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(imgUrl),
                    backgroundColor: MyColor.mooncloud,
                  ),
                  Container(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(sender,style: TextStyle(color: MyColor.accent,fontSize: 11,fontWeight: FontWeight.bold),),
                      Container(height: 2,),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onLongPress: (){
                              ClipboardManager.copyToClipBoard(url);
                              showToast('Content url copied');
                            },
                            onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                        builder:(BuildContext context) => new ViewImage(url: url,)
                                  )
                                );
                              },
                            child: 
                            Container(
                              constraints: BoxConstraints(minWidth: 20,maxWidth: MediaQuery.of(context).size.width-100),
                              child: 
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              child: 
                              Column(children: <Widget>[
                              // Linkify(
                              //   text: text,
                              //   onOpen: (LinkableElement url){launch(url.url);},
                              //   style: TextStyle(color: Colors.black),
                              //   //linkStyle: TextStyle(color: Colors.yellow[100]),
                              // ),
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(url)
                                  )
                                ),
                              )
                            ],)
                              //child:Text(text,style: TextStyle(color: Colors.black),)
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(time ,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              ),
                              Text(' ' ,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                        ],
                      )
                    ],
                  )
            ],
          ),
        );
}