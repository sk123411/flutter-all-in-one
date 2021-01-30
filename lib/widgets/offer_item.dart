import 'package:flutter/material.dart';

class Offeritem extends StatelessWidget{

final String image;
final String title;
final String description;
final DateTime dateTime;
final String link;


  const Offeritem({Key key, 
  this.image, this.title, this.description, this.dateTime,this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      margin: EdgeInsets.all(5.0),
      elevation: 8.0,
      child: Container(
        height: 150,
        child: Row(
          
          children: [

            Container(
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 90,
                  
                  child: Image.network(image)),
              ),
            ),

            Expanded(
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                

                children:[
                Text(title,style: TextStyle(fontFamily: "Sens-Seriff", fontWeight: FontWeight.w700,
                 fontSize: 18.0),),
                 SizedBox(height:8.0),
                 Text(description,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),),
                 SizedBox(height:4.0),
                 Text(dateTime.toLocal().toString())
                

            ]),
              )) 
          



        ],),
      ),
    );


  }






}