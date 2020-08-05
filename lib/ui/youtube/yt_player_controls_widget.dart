import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/yt_controller_bloc.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayerControls extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTPlayerControlsState();
  }
}

class YTPlayerControlsState extends State<YTPlayerControls>{

 //final YoutubeControllerBloc _youtubeControllerBloc;

  YoutubePlayerController _ytController;
  YTPControllerBloc _ytpControllerBloc;
  AppBloc _appBloc ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _ytpControllerBloc = _appBloc.ytpControllerBloc;
    _ytController = _ytpControllerBloc.youtubePlayerController;


  }
  @override
  Widget build(BuildContext context) {

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
                  StreamBuilder<String>(
                      stream: _ytpControllerBloc.blk_1_Stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          List<String> ls = snapshot.data.split(":");
                          // print(int.parse(ls[1]));
                          return cordsContainer(ls[0],60,60,false,int.parse(ls[1]));
                        }

                        else return cordsContainer('',60,60,false,0);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child:StreamBuilder<String>(
                        stream: _ytpControllerBloc.blk_2_Stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            List<String> ls = snapshot.data.split(":");
                            // print(int.parse(ls[1]));
                            return cordsContainer(ls[0],60,60,false,int.parse(ls[1]));
                          }

                          else return cordsContainer('',60,60,false,0);
                        }
                    ),
                  ),
                  Expanded(
                    child:StreamBuilder<String>(
                      stream: _ytpControllerBloc.current_blk_Stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){

                          return currentCordContainer(snapshot.data,80,60,true,0);
                        }

                        else return currentCordContainer('',80,60,true,0);
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child:StreamBuilder<String>(
                        stream: _ytpControllerBloc.blk_4_Stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            List<String> ls = snapshot.data.split(":");
                           // print(int.parse(ls[1]));
                            return cordsContainer(ls[0],60,60,false,int.parse(ls[1]));
                          }

                          else return cordsContainer('',60,60,false,0);
                        }
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: _ytpControllerBloc.blk_5_Stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          List<String> ls = snapshot.data.split(":");
                          return cordsContainer(ls[0],60,60,false,int.parse(ls[1]));
                        }

                        else return cordsContainer('',60,60,false,0);
                      }
                  )
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
                  _ytController.seekTo(Duration(seconds: (_ytController.value.position
                      .inSeconds - 10)));
                },
                ),
                StreamBuilder<bool>(builder: (context,snapshot){

                  if(snapshot.hasData){
                    return InkWell(
                      child: Container(child:Align(child:
                      IconButton(icon: Icon(snapshot.data?
                      Icons.pause_circle_filled:Icons.play_circle_filled,
                        color: Color(0xffA5A5A5),size: 36,),
                        alignment: Alignment.topLeft,),),
                      ),onTap: (){
                    snapshot.data
                      ? _ytpControllerBloc.pause()
                      : _ytpControllerBloc.play();
                },
                    );
                  }
                  else
                    return Container();

                },
                  stream: _ytpControllerBloc.videoPlayingStreamControllerStream,),

                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_forward ,
                      color: Color(0xffA5A5A5),size: 36,),
                    )),
                  )),onTap: (){
                  _ytController.seekTo(Duration(seconds: (_ytController.value.position
                      .inSeconds + 10)));
                }
                ),
                StreamBuilder<bool>(builder: (context,snapshot){

                  if(snapshot.hasData){
                    return InkWell(
                      child: Container(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: IconButton(icon: Icon(snapshot.data?Icons.volume_off:
                    Icons.volume_up,
                          color: Color(0xffA5A5A5),size: 36,),
                        )),
                      ),),onTap: (){

                  snapshot.data
                      ? _ytpControllerBloc.unMute() : _ytpControllerBloc.mute();

                }
                    );
                  }
                  else return Container();

                },
                  stream:_ytpControllerBloc.volumeStreamControllerStream ,),

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



  Widget cordsContainer(String text,double _width,double _height,bool currentBlock,int count) {

    return  Container(
      width: _width,
      height: _height,
      child:
      Column(children: <Widget>[
        Spacer(flex: 1,),
        Text(text,style: TextStyle(fontSize: 24,color: Color(0xffD48A31)),),
        Spacer(flex: 1,),
        !currentBlock?Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
          child: chordDotsRowWidget(count),
        ):Container(),

      ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xff222727),
          border: Border.all(width: 0.8,color: Colors.white60),
          borderRadius: BorderRadius.circular(10.0)
      ),
    );
  }

  Widget currentCordContainer(String text,double _width,double _height,bool currentBlock,int count) {

    return  Container(
      width: _width,
      height: _height,
      child:
      Stack(
        children: <Widget>[

          Container(

              height: _height,
              child: LinearProgressIndicator(
                value: 0,
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff058377)),  // 068C59
                backgroundColor: Colors.black87,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                  border: Border.all(width: 0.8,color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              Spacer(flex: 1,),
              Text(text,style: TextStyle(fontSize: 24,color: Color(0xffD48A31)),),
              Spacer(flex: 1,),

            ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          )
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xff222727),
          border: Border.all(width: 0.8,color: Colors.white60),
          borderRadius: BorderRadius.circular(10.0)
      ),
    );
  }

  Widget chordDotsRowWidget(int count){
    if(count>0){
      return
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: chordsDotsWidget(count)

        );
    }else{
      return Container();
    }
  }

  List<Widget> chordsDotsWidget(int count){

    var ls = new List<Widget>();
    for(int i=0;i<count;i++)
      ls.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child:Container(height: 2.0,color: Colors.white),
        ),
      ));
    return ls;
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
      child: StreamBuilder<double>(

        stream:BlocProvider.of<AppBloc>(context).ytpControllerBloc.progressPercentStream,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return LinearProgressIndicator(
              value: snapshot.data,
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff01AE6D)),  // 068C59
              backgroundColor: Colors.black87,
            );
          }else return Container();
        },
      )

    );
  }

}