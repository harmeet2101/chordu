import 'package:chordu/rest/chord_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordsGridWidget extends StatefulWidget{

  bool isExpanded = false;
  List<ChordInfo> chordsInfoList = new List();

  ChordsGridWidget({this.chordsInfoList,this.isExpanded});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChordsGridState();
  }
}

class ChordsGridState extends State<ChordsGridWidget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !widget.isExpanded?Container(
      width: MediaQuery.of(context).size.width-20,
      height: 250,
      decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white60,width: 0.5)
      ),

      child: Stack(
        children: <Widget>[
          gridView(),
          Positioned(child:InkWell(
            child: Container(

                width: MediaQuery.of(context).size.width-20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Read More',style: TextStyle(fontSize: 22,color: Color(0xffCBE5E8)),),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    border: Border(
                        top: BorderSide(width: 1.5,color: Color(0xff0CAE7A))
                    )
                )

            ),
            onTap: (){

              setState(() {
                widget.isExpanded = !widget.isExpanded;
              });
            },
          ),
              bottom: 0.0)
        ],
      ),
    ):gridView();
  }



  Widget gridView(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: GridView.count(
          primary: false,
          physics: !widget.isExpanded?NeverScrollableScrollPhysics():ClampingScrollPhysics(),
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

  List getChordsList(){

    List<Widget> wl = new List();

    for(int i =1;i<=widget.chordsInfoList.length;i++){

      wl.add(CordsContainer(widget.chordsInfoList[i-1].text,widget.chordsInfoList[i-1].isActive));
    }
    return wl;
  }

  Widget CordsContainer(String text,bool isActive) {

    return  InkWell(
      onTap: (){

      },
      child: Container(
        width: 50,
        height: 50,
        child:
        Center(child: Text(text,style: TextStyle(fontSize: 20,color: isActive?Color(0xffD48A31):Colors.black54),),),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isActive?Color(0xff32383C):Colors.black54,
            border: Border.all(width: 1,color: isActive?Colors.white38:Colors.black54),
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }
}