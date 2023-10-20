import 'dart:io';


import 'package:chataplication/MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _name =TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _googleid = TextEditingController();
  TextEditingController _photo =TextEditingController();

  var name = "";
  var email = "";
  var photo = "";
  var googluid = "";
  var filedata ="";


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage('img/background.jpg'),
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: Center(
            child:
         ElevatedButton(onPressed: () async{
         final GoogleSignIn googleSignIn = GoogleSignIn();
          final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
           if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
              final AuthCredential authCredential = GoogleAuthProvider.credential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken);

                  // Getting users credential
            UserCredential result = await auth.signInWithCredential(authCredential);
             User user = result.user!;

             var name = user.displayName.toString();
              var email = user.email.toString();
             var photo = user.photoURL.toString();
              var googleid = user.uid.toString();




              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("islogin", "yes");

              prefs.setString("name" ,name);
              prefs.setString("email", email);
              prefs.setString("photo", photo);
              prefs.setString("googleid",googleid);



              //check
              await FirebaseFirestore.instance.collection("user").where("email",isEqualTo: email).get().then((documents) async{
                if(documents.size<=0)
                  {
                    //firebase
                    await FirebaseFirestore.instance.collection("user").add({
                      "name": name,
                      "email": email,
                      "googleid": googleid,
                      "photo": photo,
                      "token":prefs.getString("token").toString(),
                    }).then((document) async{
                      prefs.setString("senderid", document.id.toString());
                      print("data inserted");
                      _name.text = "";
                      _email.text = "";
                      _googleid.text = "";
                      _photo.text = "";
                    }).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MainScreen())
                      );
                    });
                  }
                else
                  {
                    prefs.setString("senderid", documents.docs.first.id.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MainScreen())
                    );
                  }
              });








                 //sp



           }
       },
         child: Text("login screen..")),

      ),
      ),
    );
  }
}
