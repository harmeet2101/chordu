import 'package:flutter/material.dart';
import 'package:chordu/ui/custom_player_screen.dart';
import 'dart:async';

class SecondTabView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SecondTabViewState();
  }
}

class SecondTabViewState extends State<SecondTabView>{

  PlayerScreenState playerScreenState = null;

  @override
  Widget build(BuildContext context) {
    playerScreenState = PlayerScreenState.of(context);
    // TODO: implement build
    return  Row(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        InkWell(
          onTap: (){

            setState(() {
              playerScreenState.isSimpleChordTabSelected = true;
              playerScreenState.isAdvChordTabSelected = false;
              playerScreenState.showFirst = false;
              animateDelay();

            });
          },
          child:tab02('Simple Chords'),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0,0, 0),
          child: InkWell(
            onTap: (){
              setState(() {
                playerScreenState.isSimpleChordTabSelected = false;
                playerScreenState.isAdvChordTabSelected = true;

                playerScreenState.showFirst = false;
                animateDelay();

              });
            },
            child: tab04('Advance Chords'),
          ),
        ),


      ],
    );
  }

  Widget tab02(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: playerScreenState.isSimpleChordTabSelected?
                  Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:playerScreenState.
            isSimpleChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: playerScreenState.isSimpleChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }
  Widget tab04(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: playerScreenState.isAdvChordTabSelected?Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:playerScreenState.isAdvChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: playerScreenState.isAdvChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }

  animateDelay()async{

    var _duration = Duration(milliseconds: 5000);
    new Timer(_duration, temp );
  }

  void temp(){

    setState(() {
      playerScreenState.showFirst = true;
    });
  }
}