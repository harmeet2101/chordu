import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget{

  String videoId;
  String thumbnailUrl;
  String title;
  PlayerScreen({this.videoId,this.thumbnailUrl,this.title});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerScreenState();
  }
}

class PlayerScreenState extends State<PlayerScreen>{

  YoutubePlayerController _controller;

  @override
  void initState(){
    _controller = YoutubePlayerController
      (initialVideoId: widget.videoId,
        flags: YoutubePlayerFlags(

            autoPlay: true,
            isLive: true,
            loop: false,
            forceHD: false,
            disableDragSeek: false
        )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text(AppConstants.APP_NAME),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:(){

          Navigator.pop(context);
        }
        ),
        actions: <Widget>[

          InkWell(

            onTap: (){

            },
            child: Container(
              width: 55,
              child: Icon(Icons.account_circle,size: 40,),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[800],
        child: Column(
          children: <Widget>[

            getHeading(widget.title),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height*0.5,
                child: YoutubePlayer(
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blue,
                  aspectRatio: 16/9,
                  thumbnailUrl: widget.thumbnailUrl,
                  progressColors: ProgressBarColors(

                      playedColor: Colors.blue,
                      handleColor:  Colors.blueAccent
                  ),
                  controller: _controller,
                  onEnded: (value){

                  },
                  onReady: (){
                    print('player ready');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
  Widget getHeading(String heading){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(

        children: <Widget>[

          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Icon(Icons.music_note,
            color: Color(0xff058377),size: 40,),),
          Expanded(child: Text(heading,style: TextStyle(color: Colors.white60,fontSize: 25,fontFamily: 'Play'),
            softWrap: true,maxLines: 2,)
          ,flex: 1,
          )
        ],
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}