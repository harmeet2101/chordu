import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridControls extends StatefulWidget{

  Function gridScrollCallback;

  GridControls({this.gridScrollCallback});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GridControlState();
  }
}

class GridControlState extends State<GridControls>{

  bool autoScroll = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){

                  setState(() {
                    autoScroll = !autoScroll;
                  });
                  widget.gridScrollCallback(autoScroll);
              },
              child: Container(width: 40,height: 40,child: autoScroll?Icon(Icons.remove_circle,
                color: Colors.white,size: 28,):Icon(Icons.check_circle,
                color: Colors.white,size: 28,),
                decoration:BoxDecoration(
                  color: Color(0xff293737),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){},
              child: Container(width: 40,height: 40,child: Icon(Icons.visibility_off,
                color:Colors.white,size: 28,),
                  decoration:BoxDecoration(

                    color: Color(0xff0B3937),
                    borderRadius: BorderRadius.circular(6),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){},
              child: Container(width: 40,height: 40,child: Icon(Icons.file_download,
                color:Colors.white,size: 28,),
                  decoration:BoxDecoration(
                    color: Color(0xff293737),
                    borderRadius: BorderRadius.circular(6),
                  )
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),

    );
  }
}