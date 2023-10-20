import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cloudnotification extends StatefulWidget {
  const Cloudnotification({Key? key}) : super(key: key);

  @override
  State<Cloudnotification> createState() => _CloudnotificationState();
}

class _CloudnotificationState extends State<Cloudnotification> {
  var token="";


  getdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token").toString();
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
        title: Text("cloud notification"),
      ),
      body: Center(
        child: Text(" "+ token,style: TextStyle(fontSize: 25.0),),
      ),
    );
  }
}
