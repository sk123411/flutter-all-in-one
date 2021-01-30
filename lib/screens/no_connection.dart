import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotConnectedScreen extends StatelessWidget{
final String title;
  static String route="/noconnected";
  const NotConnectedScreen({Key key, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
          home: Scaffold(appBar:AppBar(title: Text("All in one shop app"),),
      body: Center(
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w700),),
      ),),
    );
  }



}