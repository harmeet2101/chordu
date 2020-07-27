import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/material.dart';

class YTAppBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverAppBar(

      flexibleSpace: Container(
        child: FlexibleSpaceBar(
          title: Text(AppConstants.APP_NAME),
        ),
        decoration: BoxDecoration(

          gradient: LinearGradient(colors: [Color(0xff0D4947),Colors.black87],stops: [0.4,1],
              begin:Alignment.topLeft,end: Alignment.bottomLeft
          ),
        ),
      ),
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:(){

        Navigator.pop(context);
      }
      ),
      floating: true,
      actions: <Widget>[

        InkWell(

          onTap: (){

          },
          child: Container(
            width: 55,
            child: Icon(Icons.account_circle,size: 40,),
          ),
        )
      ],
    );
  }
}