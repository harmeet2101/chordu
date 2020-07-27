
import 'package:chordu/ui/custom_player_screen.dart';
import 'package:chordu/ui/temp/player_controls_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeWebViewWidget extends StatefulWidget{

  String url;

  YouTubeWebViewWidget({this.url});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YouTubeWebViewState();
  }

}

class YouTubeWebViewState extends State<YouTubeWebViewWidget>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final PlayerScreenState state =  PlayerScreenState.of(context);
    return YoutubePlayer(
      thumbnailUrl: widget.url,
      controller: state.controller,
      onEnded: (value){
        print('ended');
        state.playerState=PlayerState.ended;
        setState(() {

          state.controller.pause();
        });
      },
      onReady: (){
        print('player ready');
        state.isPlayerReady = true;
      },

    );
  }
}