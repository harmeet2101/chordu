import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChorduAppDetails extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(

      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(AppConstants.HOME_PAGE_DESC_TEXT_1,style: TextStyle(color: Colors.greenAccent,fontSize: 16),),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(AppConstants.HOME_PAGE_DESC_TEXT_2,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
                Text(AppConstants.HOME_PAGE_DESC_TEXT_3,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),)
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0),child:
          Text(AppConstants.HOME_PAGE_DESC_TEXT_4,style: TextStyle(color: Colors.orangeAccent,fontSize: 14),),),
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child:
          Text(AppConstants.HOME_PAGE_DESC_TEXT_5,textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54,fontSize: 14,height: 1.5),)
            ,)

        ],
      ),
    );
  }
}