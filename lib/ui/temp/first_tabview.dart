import 'package:chordu/ui/custom_player_screen.dart';
import 'package:flutter/material.dart';

class FirstTabView extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FirstTabViewState();
  }
}
class FirstTabViewState extends State<FirstTabView>{

 PlayerScreenState playerScreenState = null;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    playerScreenState = PlayerScreenState.of(context);
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            InkWell(
              onTap: (){

                setState(() {
                  playerScreenState.isDiagramTabSelected = true;
                  playerScreenState.isChordTabSelected = false;
                  playerScreenState.isExpanded = false;
                });
              },
              child:tab01('Diagram Slider'),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0,0, 0),
              child: InkWell(
                onTap: (){
                  setState(() {
                    playerScreenState.isDiagramTabSelected = false;
                    playerScreenState.isChordTabSelected = true;
                  });
                },
                child: tab03('Chord Sheet'),
              ),
            ),


          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0, 10, 5),
          child: Text(playerScreenState.timeElapsed,style: TextStyle(fontSize: 26,
              color: Colors.white38),),
        ),
      ],
    );
  }


  Widget tab01(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            playerScreenState.isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):
            new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: playerScreenState.isDiagramTabSelected?Colors.white70:Colors.white),),
            ),
            playerScreenState.isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container()
          ],
        ),
        decoration: BoxDecoration(

          color: playerScreenState.isDiagramTabSelected?Color(0xff202020):Color(0xff004F59),
          shape: BoxShape.rectangle,
          borderRadius:BorderRadius.circular(6.0),


        ));
  }
  Widget tab03(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            playerScreenState.isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: playerScreenState.isChordTabSelected?Colors.white70:Colors.white),),
            ),
            playerScreenState.isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
          ],
        ),
        decoration: BoxDecoration(

            color: playerScreenState.isChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }
}