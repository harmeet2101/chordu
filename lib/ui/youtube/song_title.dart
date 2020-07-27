import 'package:flutter/material.dart';

class SongTitle extends StatelessWidget{

  String heading;

  SongTitle({this.heading});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(

        children: <Widget>[

          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Icon(Icons.music_note,
            color: Color(0xff058377),size: 25,),),
          Expanded(child: Text(heading,style: TextStyle(color: Colors.white60,fontSize: 18,fontFamily: 'Play'),
            softWrap: true,maxLines: 2,)
            ,flex: 1,
          )
        ],
      ),
    );
  }
}