import 'dart:async';

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/repository/chord_details_repo.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/chord_details.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeControllerBloc extends Bloc{

  YoutubePlayerController _controller;

  YoutubePlayerController get controller => _controller;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  var videoId;

  StreamController<Response<ChordDetails>> _streamController = new StreamController<Response<ChordDetails>>();
  ChordDetailsRepo _chordDetailsRepo;
  Stream<Response<ChordDetails>> get chordDetailsStream =>_streamController.stream;
  StreamSink<Response<ChordDetails>> get chordDetailsSink=>_streamController.sink;


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
    )..addListener(listener);

   // _streamController = new StreamController<Response<ChordDetails>>();
    _chordDetailsRepo = new ChordDetailsRepo();
    fetchChordDetails(videoId);
  }

  void listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
    }
    if(_controller.value.isPlaying){

    }
  }


  void fetchChordDetails(String id)async{

    chordDetailsSink.add(Response.loading('Fetching chord details....'));
    try{
      ChordDetails resp = await _chordDetailsRepo.getChordDetails(id);
      print(resp);
      chordDetailsSink.add(Response.completed(resp));
    }catch(e){
      chordDetailsSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _seekToController?.dispose();
    _streamController?.close();
  }

  TextEditingController get seekToController => _seekToController;

  PlayerState get playerState => _playerState;

  YoutubeMetaData get videoMetaData => _videoMetaData;

  bool get isPlayerReady => _isPlayerReady;

}