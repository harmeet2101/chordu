import 'dart:async';

import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/yt_controller_bloc.dart';
import 'package:chordu/ui/chord_grid_widget.dart';
import 'package:chordu/ui/pages/diagram_slider_pageview.dart';
import 'package:chordu/ui/pages/transpose_box.dart';
import 'package:flutter/material.dart';

import '../full_chord_grid.dart';
class TabViewsWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TabViewState();
  }
}


class TabViewState extends State<TabViewsWidget>{

  bool isDiagramTabSelected = true;
  bool isChordTabSelected  = false;
  bool _isSimpleChordTabSelected = true;
  bool _isAdvChordTabSelected = false;
  bool selectGuitar = true,selectPiano=false, selectMandolin = false,
      selectUkulele= false;
  bool _showFirst = true;
  var selectedInstrument = 0;

  YTPControllerBloc _ytpControllerBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ytpControllerBloc = BlocProvider.of<AppBloc>(context).ytpControllerBloc;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //  playerScreenState = PlayerScreenState.of(context);
    return  Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(

              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                InkWell(
                  onTap: (){

                    setState(() {
                      isDiagramTabSelected = true;
                      isChordTabSelected = false;
                      //playerScreenState.isExpanded = false;
                    });
                  },
                  child:tab01('Diagram Slider'),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0,0, 0),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isDiagramTabSelected = false;
                        isChordTabSelected = true;
                      });
                    },
                    child: tab03('Chord Sheet'),
                  ),
                ),


              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0, 10, 5),
              child: StreamBuilder<String>(
                stream: _ytpControllerBloc.timeElapsedStream,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return Text(snapshot.data,style: TextStyle(fontSize: 26,
                        color: Colors.white38),);
                  }else return Container();
                },

              ),
            ),
          ],
        ),
        isDiagramTabSelected?Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: DiagramSliderWidget(selectedInstrumentType: selectedInstrument,
            chordsInfoList: BlocProvider.of<AppBloc>(context).
            chodDetailsBloc.chordsInfoList,counter: 0),
        ):
        new FullChordGridView(chordsInfoList: BlocProvider.of<AppBloc>(context).
        chodDetailsBloc.chordsInfoList,),
        isDiagramTabSelected?Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              InkWell(
                onTap: (){

                  setState(() {
                    _isSimpleChordTabSelected = true;
                    _isAdvChordTabSelected = false;
                    _showFirst = false;
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
                      _isSimpleChordTabSelected = false;
                      _isAdvChordTabSelected = true;

                      _showFirst = false;
                      animateDelay();

                    });
                  },
                  child: tab04('Advance Chords'),
                ),
              ),


            ],
          ),
        ):Container(),

        isDiagramTabSelected?Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: instrumentRow(),
        ):Container(),

        isDiagramTabSelected?TransposeWidget(showFirst: _showFirst,
          isTuneDialog: false,)
            :Container(),

        isDiagramTabSelected?Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0,10),
          child: ChordsGridWidget(chordsInfoList:BlocProvider.of<AppBloc>(context).
          chodDetailsBloc.chordsInfoList,
            isExpanded: false,type: '',),
        ):Container(),
      ],
    );
  }


  Widget tab01(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):
            new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: isDiagramTabSelected?Colors.white70:Colors.white),),
            ),
            isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container()
          ],
        ),
        decoration: BoxDecoration(

          color: isDiagramTabSelected?Color(0xff202020):Color(0xff004F59),
          shape: BoxShape.rectangle,
          borderRadius:BorderRadius.circular(6.0),


        ));
  }

  Widget tab03(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: isChordTabSelected?Colors.white70:Colors.white),),
            ), isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
          ],
        ),
        decoration: BoxDecoration(

            color: isChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }

  Widget tab02(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: _isSimpleChordTabSelected?Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:_isSimpleChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: _isSimpleChordTabSelected?Color(0xff202020):Color(0xff004F59),
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
                  color: _isAdvChordTabSelected?Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:_isAdvChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: _isAdvChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }


  Widget instrumentRow(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Guitar',selectGuitar),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: instrumentItem('Piano',selectPiano),
        ),
        instrumentItem('Ukulele',selectUkulele),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Mandolin',selectMandolin),
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
              selectGuitar = true;
              selectPiano = false;
              selectUkulele = false;
              selectMandolin = false;
              selectedInstrument = 0;
            }else if(instrumentName == 'Piano'){
              selectGuitar = false;
              selectPiano = true;
              selectUkulele = false;
              selectMandolin = false;
              selectedInstrument = 1;
            }else if(instrumentName == 'Ukulele'){
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = true;
              selectMandolin = false;
              selectedInstrument = 2;
            }else{
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = false;
              selectMandolin = true;
              selectedInstrument = 3;
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







  animateDelay()async{

    var _duration = Duration(milliseconds: 5000);
    new Timer(_duration, temp );
  }

  void temp(){

    setState(() {
      _showFirst = true;
    });
  }
}