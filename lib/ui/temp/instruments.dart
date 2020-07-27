import 'package:flutter/material.dart';
import 'package:chordu/ui/custom_player_screen.dart';


class InstrumentWidget extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return InstrumentState();
  }

}

class InstrumentState extends State<InstrumentWidget>{

  PlayerScreenState playerScreenState = null;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    playerScreenState = PlayerScreenState.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Guitar',playerScreenState.selectGuitar),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: instrumentItem('Piano',playerScreenState.selectPiano),
        ),
        instrumentItem('Ukulele',playerScreenState.selectUkulele),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Mandolin',playerScreenState.selectMandolin),
        ),

      ],
    );
  }

  Widget instrumentItem(String instrumentName,bool _defaultSelection){

    return Container(

      decoration: BoxDecoration(
          color: _defaultSelection?Color(0xff1F1F1F):Color(0xff505152),
          border: Border.all(color:  _defaultSelection?Colors.white60:Colors.grey,width: 0.8),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: InkWell(
        onTap: (){

          setState(() {
            if(instrumentName=='Guitar'){
              playerScreenState.selectGuitar = true;
              playerScreenState.selectPiano = false;
              playerScreenState.selectUkulele = false;
              playerScreenState.selectMandolin = false;
              playerScreenState.selectedInstrument = 0;
            }else if(instrumentName == 'Piano'){
              playerScreenState.selectGuitar = false;
              playerScreenState.selectPiano = true;
              playerScreenState.selectUkulele = false;
              playerScreenState.selectMandolin = false;
              playerScreenState.selectedInstrument = 1;
            }else if(instrumentName == 'Ukulele'){
              playerScreenState.selectGuitar = false;
              playerScreenState.selectPiano = false;
              playerScreenState.selectUkulele = true;
              playerScreenState.selectMandolin = false;
              playerScreenState.selectedInstrument = 2;
            }else{
              playerScreenState.selectGuitar = false;
              playerScreenState.selectPiano = false;
              playerScreenState.selectUkulele = false;
              playerScreenState.selectMandolin = true;
              playerScreenState.selectedInstrument = 3;
            }
          });

        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(instrumentName,style: TextStyle(fontSize: 16,color: Colors.white),),
        ),
      ),
    );
  }

}