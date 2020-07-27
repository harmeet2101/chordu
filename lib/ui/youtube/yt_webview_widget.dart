import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/you_tube_controller_bloc.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTWebviewWidget extends StatefulWidget{

  String url;
  String videoId;
  YTWebviewWidget({this.url,this.videoId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTWebviewWidgetState();
  }
}

class YTWebviewWidgetState extends State<YTWebviewWidget>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    YoutubePlayerController _ytController = BlocProvider.of<YoutubeControllerBloc>(context).controller;
    return YoutubePlayer(
      thumbnailUrl: widget.url,
      controller: _ytController,
      onEnded: (value){
        print('ended');

      },
      onReady: (){
        print('player ready');

      },

    );
  }
}