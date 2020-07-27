import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Column(

        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(flex: 1,),
              IconButton(icon: Icon(Icons.close,color:Colors.white,size: 28,),onPressed: (){

                Navigator.pop(context);
              },),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 20),
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 250,
                height: 50,
                child: Center(child: Text(AppConstants.DIALOG_LOGIN_HEADING,
                  style: TextStyle(color: Colors.white,fontSize: 22.0,decoration: TextDecoration.none),),
                ),
                decoration:BoxDecoration(
                    color: Color(0xff058377),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Colors.white60,width: 0.5)
                ) ,
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 180,
                height: 40,
                child: Center(child: Text(AppConstants.DIALOG_LOGIN_GOOGLE_HEADING,
                  style: TextStyle(color: Colors.white,fontSize: 15.0,decoration: TextDecoration.none),),
                ),
                decoration:BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Colors.white60,width: 0.5)
                ) ,
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 220,
                height: 40,
                child: Center(child: Text(AppConstants.DIALOG_LOGIN_FACEBOOK_HEADING,
                  style: TextStyle(color: Colors.white,fontSize: 15.0,decoration: TextDecoration.none),),
                ),
                decoration:BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Colors.white60,width: 0.5)
                ) ,
              ),

            ),
          ),
        ],

      ),
        decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white60,width: 2)
        )
    );
  }
}