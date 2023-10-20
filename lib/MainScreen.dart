import 'package:chataplication/ChattScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  var name="";
  var email="";
  var photo="";
  var googleid="";
  var senderid="";
  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name").toString();
      email = prefs.getString("email").toString();
      photo =prefs.getString("photo").toString();
      googleid = prefs.getString("googleid").toString();
      senderid = prefs.getString("senderid").toString();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
        actions: [
          IconButton(onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();

            final GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.signOut();

            Navigator.of(context).pop();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
              icon: Icon(Icons.logout),),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.purpleAccent.shade100,
        child: ListView(
          children: [
            ListTile(
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child:Center(
                  child: Text("Welcome to chatt app...",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w900,color: Colors.black),),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200,),
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            ListTile(
              title:  Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child:Text("Name: "+name),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200,),
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            ListTile(
              title:  Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child:  Text("E-mail:"+email),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200,),
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            ListTile(
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Text(photo),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200,),
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            ListTile(
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Text("Google-id:" +googleid) ,
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200,),
                    borderRadius: BorderRadius.circular(10.0)
                ),

              ),
            ),

          ],
        ),
      ),
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection("user").where("email",isNotEqualTo: email).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots)
        {
          if(snapshots.hasData)
            {
              if(snapshots.data!.size <= 0)
                {
                  return Center(
                    child: Text("No Data!"),
                  );
                }
              else
                {
                  return ListView(
                    children: snapshots.data!.docs.map((document){
                      return ListTile(
                        title: Text(document["name"].toString()),
                        subtitle: Text(document["email"].toString()),
                        leading: Image.network(document["photo"].toString()),
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ChattScreen(
                              name: document["name"].toString(),
                              email: document["email"].toString(),
                              photo : document["photo"].toString(),
                              receiverid: document.id.toString(),
                              receivertoken:  document["token"].toString(),
                            ))
                          );
                        },
                      );
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
        },

      ),
    );
  }
}

