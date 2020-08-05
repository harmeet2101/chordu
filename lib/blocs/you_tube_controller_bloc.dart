import 'dart:async';

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/repository/chord_details_repo.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/utils/common_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeControllerBloc extends Bloc{

  YoutubePlayerController _controller;

  YoutubePlayerController get controller => _controller;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _isLoading = true;
  var videoId;
  String timeElapsed = '0:00';
  double _percentage = 0.0;
  double _Progresspercentage = 0.0;

  StreamController<Response<String>> _streamController = new StreamController<Response<String>>();
  Stream<Response<String>> get youtubeControllersStream =>_streamController.stream;
  StreamSink<Response<String>> get youtubeControllerSink=>_streamController.sink;


  YoutubeControllerBloc({this.videoId}){

    _controller = YoutubePlayerController
      (initialVideoId: videoId,
        flags: YoutubePlayerFlags(

          mute: false,
          autoPlay: true,
          isLive: false,
          loop: false,
          forceHD: false,
          disableDragSeek: false,
          enableCaption: false,
        )
    );
    _controller.addListener(listener);

    youtubeControllerSink.add(new Response.loading('loading......'));

  }

  void listener() {

    if (_isPlayerReady && !_controller.value.isFullScreen) {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
      //print('test##############################################################');
    }
    if(_controller.value.isPlaying){
      print('playing....');
      _isLoading = false;
      youtubeControllerSink.add(new Response.completed('done......'));

      timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
      _Progresspercentage = (_controller.value.position.inMilliseconds /
          _controller.metadata.duration.inMilliseconds);

    }
  }
  bool _muted = false;
  bool get muted => _muted;

  set muted(bool value) {
    _muted = value;
  }
  bool get isLoading => _isLoading;

  @override
  void dispose() {

    _controller?.dispose();
    _seekToController?.dispose();
  }

  TextEditingController get seekToController => _seekToController;

  PlayerState get playerState => _playerState;

  YoutubeMetaData get videoMetaData => _videoMetaData;

  bool get isPlayerReady => _isPlayerReady;

  set isPlayerReady(bool value) {
    _isPlayerReady = value;
   // print(_isPlayerReady);
  }


}