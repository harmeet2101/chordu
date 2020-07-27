import 'dart:ui';

import 'package:chordu/ui/pages/transpose_box.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TuneChordsDialog extends StatefulWidget{

 @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TuneChordDialogState();
  }
}

class TuneChordDialogState extends State<TuneChordsDialog>{

  bool transposeSwitch = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

        height: 370,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Spacer(flex: 1,),
                IconButton(icon: Icon(Icons.close,color:Colors.white,size: 28,),onPressed: (){

                  Navigator.pop(context);
                },),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  width: 250,
                  height: 50,
                  child: Center(child: Text(AppConstants.DIALOG_TUNING_HEADING,
                    style: TextStyle(color: Colors.white,fontSize: 22.0,decoration: TextDecoration.none),),
                  ),
                  decoration:BoxDecoration(
                      color: Color(0xff058377),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.white60,width: 0.5)
                  ) ,
                ),

              ),
            ),
            Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Transpose',style: TextStyle(fontSize: 22,color: Colors.grey[400]),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text('Off',style: TextStyle(fontSize: 22,color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            width: 30,
                            child: Center(
                              child: Icon(Icons.add,color: Colors.black,),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          width: 30,
                          child: Center(
                            child: Icon(Icons.remove,color: Colors.black,),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,0),
                  child: Text('Am C F A Bb Fm Dm',style: TextStyle(fontSize: 18,color: Colors.greenAccent),),),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoSwitch(value: transposeSwitch, onChanged: (bool value){
                       setState(() {
                            transposeSwitch = value;
                          });
                    },activeColor: Color(0xff0E8291),trackColor: Colors.grey[400],),
                    Text('Save Tuning',style: TextStyle(fontSize: 18,color: Color(0xffCBE5E8)),)
                  ],
                )
                  ,),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,0),
                  child: Text('Use Flats, Sharpes or Both ?',style: TextStyle(fontSize: 18,color: Colors.grey[400]),),),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,10),child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    transposeCordsContainer('b', 40, 40,true),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0, 10, 0),
                      child: transposeCordsContainer('#', 40, 40,false),
                    ),
                    transposeCordsContainer('#b', 40, 40,false),
                  ],
                ),),

              ],
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white60,width: 2)
        )
    );



  }
  Widget transposeCordsContainer(String text,double _width,double _height,bool isActive) {

    return  InkWell(
      onTap: (){

      },
      child: Container(
        width: _width,
        height: _height,
        child:
        Center(child: Text(text,style: TextStyle(fontSize: 24,color: isActive?Colors.white:Color(0xff777777)),),),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isActive?Color(0xff0E5950):Color(0xffDADADA),
            border: Border.all(width: 1,color: Colors.white),
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }
}