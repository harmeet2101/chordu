import 'package:flutter/material.dart';

class YTPlayerControls extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTPlayerControlsState();
  }
}

class YTPlayerControlsState extends State<YTPlayerControls>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      width: MediaQuery.of(context).size.width,

      color: Colors.black87,

      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  cordsContainer('F',60,60),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer('Am',60,60),
                  ),
                  Expanded(
                    child:cordsContainer('C',80,60),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer('Bb',60,60),
                  ),
                  cordsContainer('Fm',60,60),
                ],
              ),
            ),
          ),
          LinearProgressWidget(),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff222727),Color(0xff252B2C),Color(0xff1E2121)],
                    begin:Alignment.topCenter ,end: Alignment.bottomCenter,stops: [0.2,0.5,0.9])
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                    child: Center(child: IconButton(icon: Icon(Icons.favorite,color: Color(0xffA17465),size: 36,),)),
                  ),),
                  onTap: (){

                  },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.share,color: Color(0xffA5A5A5),size: 36,),
                    )),
                  ),),
                  onTap: (){

                  },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_rewind,color: Color(0xffA5A5A5),size: 36,),
                    ),),
                  )),onTap: (){

                },
                ),
                InkWell(
                  child: Container(child:Align(child:
                  IconButton(icon: Icon(Icons.play_circle_filled,
                    color: Color(0xffA5A5A5),size: 36,),
                    alignment: Alignment.topLeft,),),
                  ),onTap:(){

                },
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_forward ,
                      color: Color(0xffA5A5A5),size: 36,),
                    )),
                  )),onTap: (){

                }
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.volume_up,
                      color: Color(0xffA5A5A5),size: 36,),
                    )),
                  ),),onTap: (){

                }
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    child: Center(child: IconButton(icon: Icon(Icons.equalizer,color: Color(0xffBBD7D5),size: 36,),
                    )),
                  ),),
                  onTap: (){

                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cordsContainer(String text,double _width,double _height) {

    return  Container(
      width: _width,
      height: _height,
      child:
      Center(child: Text(text,style: TextStyle(fontSize: 24,color: Color(0xffD48A31)),),),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xff222727),
          border: Border.all(width: 0.8,color: Colors.white60),
          borderRadius: BorderRadius.circular(10.0)
      ),
    );
  }
}


class LinearProgressWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LinearProgressState();
  }
}
class LinearProgressState extends State<LinearProgressWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(

      width: MediaQuery.of(context).size.width,
      height: 2,
      child: LinearProgressIndicator(
        value: 0.5,
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff01AE6D)),  // 068C59
        backgroundColor: Colors.black87,
      ),);
  }

}