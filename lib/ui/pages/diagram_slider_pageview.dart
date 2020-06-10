import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiagramSliderWidget extends StatefulWidget{


  DiagramSliderWidget();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DiagramSliderState();
  }
}

class DiagramSliderState extends State<DiagramSliderWidget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getDiagramSliderItems(context);
  }


  Widget getDiagramSliderItems(BuildContext buildContext){

    var imgs = {'assets/images/guitar/a.png','assets/images/guitar/A7.png',
      'assets/images/guitar/A7sus2.png','assets/images/guitar/A7sus4.png',
      'assets/images/guitar/Aadd9.png'};
    return Column(
      children: <Widget>[
        Container(
          color:Color(0xff505152),
          height: 250,
          child: CarouselSlider(

            options:  CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.4,
              aspectRatio: 2.0,
              initialPage: 1,

            ),
            items: imgs.map((e) => Container(

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
            )).toList(),
          ),
        ),

      ],
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}