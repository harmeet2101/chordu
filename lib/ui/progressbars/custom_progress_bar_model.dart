
import 'file:///D:/softwares/ChordU_app_flutter/chordu/lib/ui/progressbars/spinning_progress_view.dart';
import 'package:chordu/ui/progressbars/hour_progress_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBarModel extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProgressBarModelState();
  }

}

class ProgressBarModelState extends State<ProgressBarModel> with TickerProviderStateMixin{

  AnimationController animationController01;
  Animation _animation;
  Animation _animation02;
  Animation _animation03;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    animationController01 = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 600),
    );
    _animation = Tween<Offset>(begin: Offset(0,0),end: Offset(0,-1.5)).animate(animationController01);
    _animation02 = Tween<Offset>(begin: Offset(0,0),end: Offset(0,-1.0)).animate(animationController01);
    _animation03 = Tween<Offset>(begin: Offset(0,0),end: Offset(0,-0.5)).animate(animationController01);
    animationController01.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: [
        new Opacity(
          opacity: 0.8,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
            child: SpinHourGlass(color: Color(0xff1C99A9),size:100.0,),
        )
        ,Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width/3,
          child: Row(

            children: <Widget>[
              SlideTransition(
                position: _animation,
                child: getProgressDotConatiner(),),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SlideTransition(
                  position: _animation02,
                  child: getProgressDotConatiner(),
                ),
              ),
              SlideTransition(
                position: _animation03,
                child:getProgressDotConatiner(),
              )

            ],
          ),
        )
      ],
    );
  }

  Widget getProgressDotConatiner(){
    return Container(
      width: 42,
      height: 33,
      decoration: BoxDecoration(
        color: Color(0xff1C99A9),
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.white,width: 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    animationController01.dispose();
    super.dispose();
  }
}

