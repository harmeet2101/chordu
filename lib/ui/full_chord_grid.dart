import 'package:chordu/rest/chord_info.dart';
import 'package:flutter/material.dart';

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

  List<Widget> wl = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return gridView();
  }



  Widget gridView(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: GridView.count(
          primary: false,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 6,
          scrollDirection: Axis.vertical,
          children: getChordsList(),

        )
    );
  }

  List getChordsList() {

   // wl.clear();
 //   print('current block and key ${widget.currentblock} ${widget.currentKey}');
 //   print('${widget.currentKey} ${wl.length}');
    for(int i =1;i<=widget.chordsInfoList.length;i++){

        /*if(i<=widget.currentKey){
          print('inside ${i}');
          wl.add(CordsContainer(widget.chordsInfoList[i-1].text,
              widget.chordsInfoList[i-1].isActive,true));

        }else*/{
        //  print('outside ${i}');
          wl.add(CordsContainer(widget.chordsInfoList[i-1].text,
              widget.chordsInfoList[i-1].isActive,false));
        }

    }


    return wl;
  }

  Widget CordsContainer(String text,bool isActive,bool temp) {

    //print('$text $isActive $temp');
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
            color: temp?Color(0xff32383C):Colors.black54,
            border: Border.all(width: 1,color: isActive?Colors.white38:Colors.black54),
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }
}