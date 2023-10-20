
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chataplication/SaveImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChattScreen extends StatefulWidget {

  var name ="";
  var email ="";
  var photo ="";
  var receiverid="";
  var receivertoken="";
  ChattScreen({required this.name,required this.email,required this.photo,required this.receiverid,required this.receivertoken});

  @override
  State<ChattScreen> createState() => _ChattScreenState();
}

class _ChattScreenState extends State<ChattScreen> {

  var senderid="";

  ImagePicker picker = ImagePicker();

  File? selectedfile;

  var isloading=false;

  bool showemoji = false;
  var sendername="";
  
  TextEditingController _message = TextEditingController();
  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderid = prefs.getString("senderid").toString();
      sendername= prefs.getString("name").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
      FocusScope.of(context).unfocus();
    },
        child: SafeArea(
          child: WillPopScope(
              onWillPop: (){
              if(showemoji)
              {
                  setState(() =>showemoji = !showemoji);
                     return Future.value(false);

              }
              else
              {
                 return Future.value(true);
              }
              },
    child:Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed:(){
                        Navigator.pop(context);
                      } ,
                      icon: Icon(Icons.arrow_back)),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.photo),
                    radius: 20.0,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name.toString()),
                      Text(widget.email.toString()),
                    ],
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("user").doc(senderid).collection("chats")
                      .doc(widget.receiverid).collection("message").orderBy("datetime",descending: true).snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots)
                    {
                      if(snapshots.hasData)
                      {
                        if(snapshots.data!.size <= 0)
                        {
                          return Center(
                            child: Text("No messaged!"),
                          );
                        }
                        else
                        {
                          return ListView(
                            reverse: true,
                            children: snapshots.data!.docs.map((document){
                              if(senderid==document["senderid"].toString())
                                {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.all(15.0),
                                      child: (document["type"]=="image")?
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>SaveImage(fileurl: document["message"].toString()))
                                          );
                                        },
                                        child: Image.network(document["message"].toString(),width: 120.0,),
                                      ):Text(document["message"].toString(),style: TextStyle(color: Colors.white),),
                                      decoration: BoxDecoration(
                                          color: Colors.teal.shade600,
                                        borderRadius: BorderRadius.circular(10.0)
                                      ),
                                    ),
                                  );
                                }
                              else
                                {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.all(15.0),
                                      child: (document["type"]=="image")?
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context)=>SaveImage(fileurl: document["message"].toString()))
                                          );
                                        },
                                        child: Image.network(document["message"].toString(),width: 120.0,),
                                      ):Text(document["message"].toString(),style: TextStyle(color: Colors.white),),
                                      decoration: BoxDecoration(
                                          color: Colors.teal.shade500,
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                    ),
                                  );
                                }

                            }).toList(),
                          );
                        }
                      }
                      else
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                )
              ),
              Container(
                color: Colors.grey.shade100,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 5.0,right: 5.0,bottom: 5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child:Container(
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const[
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 7,
                              color: Colors.grey
                          )
                        ],),

                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                showemoji = !showemoji;
                              });
                            },
                            icon: Icon(
                              Icons.emoji_emotions_sharp,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              child: TextFormField(
                                controller: _message,
                                style: TextStyle(
                                  fontSize: 19.0,
                                ),
                                onTap: (){
                                  if(showemoji);
                                  setState(() {
                                    showemoji = false;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed:()async{
                                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                                if(photo!=null)
                                  {
                                    setState(() {
                                      isloading=true;
                                    });
                                    selectedfile = File(photo!.path);
                                    var uuid = Uuid();
                                    var filename = uuid.v4().toString();

                                    await FirebaseStorage.instance.ref(filename).putFile(selectedfile!).whenComplete((){}).then((filedata) async{
                                      await filedata.ref.getDownloadURL().then((fileurl) async{
                                        await FirebaseFirestore.instance.collection("user").doc(senderid)
                                            .collection("chats").doc(widget.receiverid).collection("message").add({
                                          "message":fileurl,
                                          "senderid":senderid,
                                          "receiverid":widget.receiverid,
                                          "type":"image",
                                          "datetime":DateTime.now().millisecondsSinceEpoch
                                        }).then((value) async{
                                          await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                                              .collection("chats").doc(senderid).collection("message").add({
                                            "message":fileurl,
                                            "senderid":senderid,
                                            "receiverid":widget.receiverid,
                                            "type":"image",
                                            "datetime":DateTime.now().millisecondsSinceEpoch
                                          }).then((value){
                                            setState(() {
                                              isloading=false;
                                            });
                                          });
                                        });
                                      });
                                    });
                                  }


                          } , icon:Icon(Icons.camera_alt,color: Colors.grey,) ),
                          IconButton(
                              onPressed: ()async{
                                final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                if(photo!=null)
                                {
                                  setState(() {
                                    isloading=true;
                                  });
                                  selectedfile = File(photo!.path);
                                  var uuid = Uuid();
                                  var filename = uuid.v4().toString();

                                  await FirebaseStorage.instance.ref(filename).putFile(selectedfile!).whenComplete((){}).then((filedata) async{
                                    await filedata.ref.getDownloadURL().then((fileurl) async{
                                      await FirebaseFirestore.instance.collection("user").doc(senderid)
                                          .collection("chats").doc(widget.receiverid).collection("message").add({
                                        "message":fileurl,
                                        "senderid":senderid,
                                        "receiverid":widget.receiverid,
                                        "type":"image",
                                        "datetime":DateTime.now().millisecondsSinceEpoch
                                      }).then((value) async{
                                        await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                                            .collection("chats").doc(senderid).collection("message").add({
                                          "message":fileurl,
                                          "senderid":senderid,
                                          "receiverid":widget.receiverid,
                                          "type":"image",
                                          "datetime":DateTime.now().millisecondsSinceEpoch
                                        }).then((value) async{



                                          // AwesomeNotifications().createNotification(
                                          //     content: NotificationContent( //with image from URL
                                          //       id: 103,
                                          //       channelKey: 'image',
                                          //       title: ' Image',
                                          //       body: 'This simple notification is from Flutter App',
                                          //       bigPicture: fileurl,
                                          //       notificationLayout: NotificationLayout.BigPicture,
                                          //     ),
                                          //     actionButtons: [
                                          //       NotificationActionButton(key: 'home', label: 'Home'),
                                          //       NotificationActionButton(key: 'about', label: 'About'),
                                          //     ]
                                          // );
                                          setState(() {
                                            isloading=false;
                                          });
                                        });
                                      });
                                    });
                                  });
                                }


                              }, icon: Icon(Icons.image,color: Colors.grey,)),

                        ],
                      ),

                    ),),
                    (isloading)?CircularProgressIndicator():GestureDetector(
                      onTap: () async {

                        //print("Receiver id "+ widget.receiverid);
                        //print("Sender id "+senderid);
                        var msg = _message.text.toString();
                        _message.text = "";
                        //sender
                        await FirebaseFirestore.instance.collection("user").doc(senderid)
                            .collection("chats").doc(widget.receiverid).collection("message").add({
                          "message":msg,
                          "senderid":senderid,
                          "receiverid":widget.receiverid,
                          "type":"text",
                          "datetime":DateTime.now().millisecondsSinceEpoch
                        }).then((value) async{
                          await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                              .collection("chats").doc(senderid).collection("message").add({
                            "message":msg,
                            "senderid":senderid,
                            "receiverid":widget.receiverid,
                            "type":"text",
                            "datetime":DateTime.now().millisecondsSinceEpoch
                          }).then((value) async{
                            print(widget.receivertoken);
                            await FirebaseMessaging.instance.sendMessage(
                              to: widget.receivertoken.toString(),
                              data: {
                              'title': 'Message from ${sendername}',
                              'body': msg,
                              },
                            );
                          });
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF00CE5E),
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ),
                        ),
                        child: Icon(
                          Icons.send,
                          size: 26.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                ),
      Offstage(
        offstage: !showemoji,
        child: SizedBox(
            height: 250,
            child: EmojiPicker(
              textEditingController: _message,
              config: Config(
                columns: 7,
                // Issue: https://github.com/flutter/flutter/issues/28894
                emojiSizeMax: 32 * 1.30,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                recentTabBehavior: RecentTabBehavior.RECENT,
                recentsLimit: 28,
                replaceEmojiOnLimitExceed: false,
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                loadingIndicator: const SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
                checkPlatformCompatibility: true,
              ),
            ))),
            ],
          ),
        ),
      ),
          ),
          ),
        ),
    );
  }
}
