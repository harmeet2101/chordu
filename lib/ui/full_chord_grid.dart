import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/yt_controller_bloc.dart';
import 'package:chordu/rest/chord_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FullChordGridView extends StatefulWidget{

  List<ChordInfo> chordsInfoList = new List();
  int counter =0;
  String currentblock;
  int currentKey = 0;
  FullChordGridView({this.chordsInfoList,this.counter,this.currentblock,
    this.currentKey});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FullChordGridState();
  }
}

class FullChordGridState extends State<FullChordGridView>{

  YTPControllerBloc _ytpControllerBloc;
  String blkText='';
  int clrLimit =0;
  //ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
   // _scrollController = ScrollController();


    super.initState();
    _ytpControllerBloc = BlocProvider.of<AppBloc>(context).ytpControllerBloc;

   /* WidgetsBinding.instance.addPostFrameCallback((_){

      _scrollController.addListener(_scrollListener());
    });*/


  }

  /*_scrollListener() {

    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('reach the bottom');

    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('reach the Top');
    }
  }*/

  /*_moveUp() {
    _scrollController.animateTo(_scrollController.offset - 50,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }
  _moveDown() {
    print(_scrollController.position.maxScrollExtent);
    _scrollController.animateTo(_scrollController.offset + 2000,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return StreamBuilder<String>(

      builder: (context,snapshot){

        if(snapshot.hasData){
          List<String> ls = snapshot.data.split(":");
          clrLimit = int.parse(ls[1]);
          return getGrid(clrLimit);
        }
        else{
          return getGrid(0);
        }},
      stream: _ytpControllerBloc.grid_view_Stream,
    );
  }

  Widget getGrid(int count){
   return GridView.count(
      primary: false,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(5),
      shrinkWrap: true,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      crossAxisCount: 6,
      scrollDirection: Axis.vertical,
      children: getChordsList(clrLimit),

    );
  }



  List getChordsList(int limit) {


    List<Widget> wl = new List();
    for(int i =1;i<=widget.chordsInfoList.length;i++){

      wl.add(CordsContainer(widget.chordsInfoList[i-1].text,
          widget.chordsInfoList[i-1].isActive,(i<=limit)?true:false,(i==limit)?true:false));
    }
    return wl;
  }


  Widget CordsContainer(String text,bool isActive,bool temp,bool isLast) {

   // print('text: $text temp: $temp');
    Color boxColor = Colors.black54;
    if(isLast){
      boxColor = Color(0xff058377);
    }else if(temp && !isLast){
      boxColor = Color(0xff32383C);
    }
    return  InkWell(
      onTap: (){

      },
      child: Container(
        width: 50,
        height: 50,
        child:
        Center(child: Text(text,style: TextStyle(fontSize: 20,color: isActive?
        Color(0xffD48A31):Colors.black54),),),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: boxColor/*temp?Color(0xff32383C):Colors.black54*/,
            border: Border.all(width: 1,color: isActive?Colors.white38:Colors.black54),
            borderRadius: BorderRadius.circular(10.0),
            gradient: isLast?LinearGradient(colors: [Color(0xff0D4947),Colors.black87],stops: [0.5,1],
                begin:Alignment.topLeft,end: Alignment.bottomLeft
            ):null
        ),
      ),
    );
  }
}

