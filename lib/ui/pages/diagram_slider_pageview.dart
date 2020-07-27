import 'package:carousel_slider/carousel_slider.dart';
import 'package:chordu/rest/chord_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiagramSliderWidget extends StatefulWidget{

  var selectedInstrumentType = 0;
  List<ChordInfo> chordsInfoList;
  var counter=0;
  DiagramSliderWidget({this.selectedInstrumentType,this.chordsInfoList,this.counter});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DiagramSliderState();
  }
}

class DiagramSliderState extends State<DiagramSliderWidget>{


  var imgsList = new List<String>();
  var textList = new List<String>();

  CarouselController _carouselController= CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

  //  print('diagram slider ${widget.selectedInstrumentType} counter ${widget.counter}');
    switch(widget.selectedInstrumentType){

      case 0:{
        test('guitar');
      }
      break;
      case 1:{
        test('piano');
      }
      break;
      case 2:{
        test('ukulele');
      }
      break;
      case 3:{
        test('mandolin');
      }
      break;
    }


    return getDiagramSliderItems(context);
  }

  void test(String instrumentType){


    imgsList.clear();
    textList.clear();

      for (int i = 0; i < widget.chordsInfoList.length; i++) {
        var name = widget.chordsInfoList[i].text;
        if (widget.chordsInfoList[i].text.isNotEmpty) {
          var str = 'assets/images/$instrumentType/${name.replaceAll(
              '#', 's')}.png';
          imgsList.add(str);
          textList.add(name);
        }
       // print('diagram slider ${instrumentType}');
      }

  }

  void moveToLoc(){
    _carouselController.animateToPage(widget.counter,
        duration: Duration(milliseconds: 300));
  }

  Widget getDiagramSliderItems(BuildContext buildContext){
    WidgetsBinding.instance.addPostFrameCallback((_) => moveToLoc());
    return Column(
      children: <Widget>[
        Container(
          color:Color(0xff505152),
          height: 250,
          child: CarouselSlider(
            carouselController: _carouselController,
            options:  CarouselOptions(
              autoPlay: false,
              reverse: false,
              enlargeCenterPage: true,
              viewportFraction: 0.4,
              aspectRatio: 2.0,
              initialPage: 1,
              autoPlayCurve: Curves.linear,
              

            ),
            items: getSliderItems()/*imgsList.map((e) => Container(

                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape:BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('C',style: TextStyle(color: Colors.black,
                          fontSize: 28,fontWeight: FontWeight.bold),),
                    ),
                    Expanded(child: Image.asset(e,fit: BoxFit.fill,)),
                  ],
                )
            )).toList()*/,
          ),
        ),
        /*RaisedButton(
          color: Colors.red,
          onPressed: (){
            moveToLoc();
          },child: Text('Next',style: TextStyle(fontSize: 16,color: Colors.white),),
        ),*/
      ],
    );
  }

  List<Widget> getSliderItems(){

    List<Widget> ls = new List();

    for(int i =0;i<imgsList.length;i++)
    ls.add(Container(

          decoration: BoxDecoration(
            color: Colors.grey,
            shape:BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(textList[i],style: TextStyle(color: Colors.black,
                    fontSize: 28,fontWeight: FontWeight.bold),),
              ),
              Expanded(child: Image.asset(imgsList[i],fit: BoxFit.fill,)),
            ],
          )
      ));

    return ls;
  }

}