import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/you_tube_controller_bloc.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/Status.dart';
import 'package:chordu/ui/progressbars/custom_progress_bar_model.dart';
import 'package:chordu/ui/youtube/yt_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTWebviewWidget extends StatefulWidget{

  String url;
  String videoId;
  Function callback;
  YTWebviewWidget({this.url,this.videoId,this.callback});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTWebviewWidgetState();
  }
}

class YTWebviewWidgetState extends State<YTWebviewWidget>{


  YoutubePlayerController _ytController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _ytController = YTMainScreenState.of(context).controller;
    return YoutubePlayer(
      thumbnailUrl: widget.url,
      controller: _ytController,
      onEnded: (value){
        print('ended');
      },
      onReady: (){
        print('player ready');
        widget.callback();
      },

    );
  }
}