import 'dart:async';
import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/blocs/chord_details_bloc.dart';
import 'package:chordu/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:async/async.dart';

class YTPControllerBloc extends Bloc{


  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  bool get isPlayerReady => _isPlayerReady;

  set isPlayerReady(bool value) {
    _isPlayerReady = value;
  }

  bool _isVideoPlaying = false;

  bool get isVideoPlaying => _isVideoPlaying;

  set isVideoPlaying(bool value) {
    _isVideoPlaying = value;
  }

  bool _muted = false;
  bool get muted => _muted;

  set muted(bool value) {
    _muted = value;
  }

  bool _isLoading = true;
  var videoId;
  String timeElapsed = '00:00';

  double _percentage = 0.0;
  double _Progresspercentage = 0.0;

  ChordDetailsBloc chordDetailsBloc;
  int counter=0;
  String block_0='',block_1='',block_2='',
      currentBlock='',block_4='',block_5='',block_6='';
  int dotSize_6=0,dotSize_5=0,dotSize_4=0,dotSize_2=0,dotSize_1=0,dotSize_0=0;
  int currentKey =0;

  YoutubePlayerController _youtubePlayerController;

  YoutubePlayerController get youtubePlayerController => _youtubePlayerController;


  StreamController<bool> _videoPlayingStreamController;
  StreamController<bool> _volumeStreamController;

  Stream<bool> get videoPlayingStreamControllerStream =>_videoPlayingStreamController.stream;
  StreamSink<bool> get videoPlayingStreamControllerSink=>_videoPlayingStreamController.sink;


  Stream<bool> get volumeStreamControllerStream =>_volumeStreamController.stream;
  StreamSink<bool> get volumeStreamControllerSink=>_volumeStreamController.sink;

  StreamController<String> _timeElapsedStreamController;
  Stream<String> get timeElapsedStream =>_timeElapsedStreamController.stream;
  Sink<String> get timeElapsedSink => _timeElapsedStreamController.sink;

  StreamController<double> _progressPercentStreamController;
  Stream<double>  get progressPercentStream =>_progressPercentStreamController.stream;
  Sink<double> get progressPercentSink =>_progressPercentStreamController.sink;

  StreamController<int> counterStreamController;
  Stream<int> get counterStream =>counterStreamController.stream;
  Sink<int> get   counterSink =>counterStreamController.sink;

  StreamController<String> _streamController_grid_view;
  Stream<String> get grid_view_Stream =>_streamController_grid_view.stream;
  Sink<String> get   grid_view_Sink =>_streamController_grid_view.sink;


  StreamController<String> _streamController_blk_1;
  Stream<String> get blk_1_Stream =>_streamController_blk_1.stream;
  Sink<String> get blk_1_Sink => _streamController_blk_1.sink;

  StreamController<String> _streamController_blk_2;
  Stream<String> get blk_2_Stream =>_streamController_blk_2.stream;
  Sink<String> get blk_2_Sink => _streamController_blk_2.sink;

  StreamController<String> _streamController_blk_4;
  Stream<String> get blk_4_Stream =>_streamController_blk_4.stream;
  Sink<String> get blk_4_Sink => _streamController_blk_4.sink;

  StreamController<String> _streamController_blk_5;
  Stream<String> get blk_5_Stream =>_streamController_blk_5.stream;
  Sink<String> get blk_5_Sink => _streamController_blk_5.sink;

  StreamController<String> _streamController_current_blk;
  Stream<String> get current_blk_Stream =>_streamController_current_blk.stream;
  Sink<String> get current_blk_Sink => _streamController_current_blk.sink;




  YTPControllerBloc({this.videoId,this.chordDetailsBloc}) {
    _youtubePlayerController = YoutubePlayerController
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
    _youtubePlayerController.addListener(listener);

    _videoPlayingStreamController = new StreamController<bool>();
    _volumeStreamController = new StreamController<bool>();
    _timeElapsedStreamController = new StreamController();
    _progressPercentStreamController = new StreamController();

    volumeStreamControllerSink.add(_muted);
    timeElapsedSink.add(timeElapsed);
  //  progressPercentSink.add(_Progresspercentage);

    counterStreamController = new StreamController<int>.broadcast();

    _streamController_blk_1 = new StreamController<String>.broadcast();
    _streamController_blk_2 = new StreamController<String>.broadcast();
    _streamController_blk_4 = new StreamController<String>.broadcast();
    _streamController_blk_5 = new StreamController<String>.broadcast();

    /*_streamController_dot_1 = new StreamController<int>.broadcast();
    _streamController_dot_2 = new StreamController<int>.broadcast();
    _streamController_dot_4 = new StreamController<int>.broadcast();
    _streamController_dot_5 = new StreamController<int>.broadcast();*/

    _streamController_current_blk = new StreamController<String>.broadcast();
    _streamController_grid_view = new StreamController<String>.broadcast();

   // counterSink.add(counter);
  }

  void listener() {

//    print('listener');
    if (_isPlayerReady && !_youtubePlayerController.value.isFullScreen) {
      _playerState = _youtubePlayerController.value.playerState;
      _videoMetaData = _youtubePlayerController.metadata;
      //print('test##############################################################');
    }
    if(_youtubePlayerController.value.isPlaying){
    //  print('playing....');
      _isLoading = false;
      _isVideoPlaying = true;
      timeElapsed = CommonUtils.convertTime(_youtubePlayerController.value.position.inMilliseconds);
      _Progresspercentage = (_youtubePlayerController.value.position.inMilliseconds /
          _youtubePlayerController.metadata.duration.inMilliseconds);

     /* var currentBlock = 0;
      var playerCurrentTime = _youtubePlayerController.value.position.inMilliseconds;
      currentBlock =  (playerCurrentTime/0.4).ceil() + 1 ;//Math.ceil(playerCurrentTime / 0.4) + 1;

      print('current blk: ${currentBlock} ${playerCurrentTime}');*/

      timeElapsedSink.add(timeElapsed);
      progressPercentSink.add(_Progresspercentage);
      videoPlayingStreamControllerSink.add(_isVideoPlaying);


      if(isFirstTime){

        isFirstTime = false;
        temp01();
      }
    }
    if(!_youtubePlayerController.value.isPlaying){
      _isVideoPlaying = false;
      isFirstTime = true;
      videoPlayingStreamControllerSink.add(_isVideoPlaying);
    }
  }

  bool isFirstTime = true;

  void play(){
    videoPlayingStreamControllerSink.add(_isVideoPlaying);
    youtubePlayerController.play();
    _isVideoPlaying = true;

  }
  void pause(){

    videoPlayingStreamControllerSink.add(_isVideoPlaying);
    youtubePlayerController.pause();
    _isVideoPlaying = false;

  }

  @override
  void dispose() {

    _youtubePlayerController?.dispose();
  }

  void mute() {

    _muted = true;
    volumeStreamControllerSink.add(_muted);
    youtubePlayerController.mute();
  }

  void unMute() {

    _muted = false;
    volumeStreamControllerSink.add(_muted);
    youtubePlayerController.unMute();
  }





  void temp01()async{

    int delay=0;

    if(chordDetailsBloc?.chordsKeyList.isNotEmpty && chordDetailsBloc?.chordsValueList.isNotEmpty){

      /*print('length: ${chordDetailsBloc.chordsValueList.length}');
      for(int i = 0; i<chordDetailsBloc.chordsKeyList.length;i++){
        print('key : ${chordDetailsBloc.chordsKeyList[i]}');
      }*/
      while(counter < chordDetailsBloc.chordsValueList.length && _isVideoPlaying){

          currentBlock = chordDetailsBloc.chordsValueList[counter];

          current_blk_Sink.add(currentBlock);
          counterSink.add(counter);

          currentKey = chordDetailsBloc.chordsKeyList[counter];
          grid_view_Sink.add('${currentBlock}:${currentKey}');

          if((counter-3)<0){
            block_0 = "";
            dotSize_0=0;
          }else{
            block_0 = chordDetailsBloc.chordsValueList[counter-3];
            dotSize_0 = chordDetailsBloc.chordsKeyList[counter-2] - chordDetailsBloc.chordsKeyList[counter-3];
          }
          if((counter-2)<0){
            block_1 = "";
            dotSize_1=0;
          }else{
            block_1 = chordDetailsBloc.chordsValueList[counter-2];
            dotSize_1 = chordDetailsBloc.chordsKeyList[counter-1]-chordDetailsBloc.chordsKeyList[counter-2];
          }
          blk_1_Sink.add('${block_1}:${dotSize_1}');
         // dot_1_Sink.add(dotSize_1);

          if((counter-1)<0){
            block_2 = "";
            dotSize_2=0;
          }else{
            block_2 = chordDetailsBloc.chordsValueList[counter-1];
            dotSize_2 = chordDetailsBloc.chordsKeyList[counter]-chordDetailsBloc.chordsKeyList[counter-1];
          }
          blk_2_Sink.add('${block_2}:${dotSize_2}');
        //  dot_2_Sink.add(dotSize_2);

          if(!(counter+1>chordDetailsBloc.chordsValueList.length-1)){
            block_4 = chordDetailsBloc.chordsValueList[counter+1];

            if(!(counter+2>chordDetailsBloc.chordsKeyList.length-1)){

              dotSize_4 = chordDetailsBloc.chordsKeyList[counter+2]-chordDetailsBloc.chordsKeyList[counter+1];
            }else{
              dotSize_4 = 0;
            }

          }else{
            block_4 = "";
          }

          blk_4_Sink.add('${block_4}:${dotSize_4}');
       //   dot_4_Sink.add(dotSize_4);

          if(!(counter+2>chordDetailsBloc.chordsValueList.length-1)){
            block_5 = chordDetailsBloc.chordsValueList[counter+2];

            if(!(counter+3>chordDetailsBloc.chordsKeyList.length-1)){

              dotSize_5 = chordDetailsBloc.chordsKeyList[counter+3]-chordDetailsBloc.chordsKeyList[counter+2];
            }else{
              dotSize_5 = 0;
            }
          }else{
            block_5 = "";
          }
          blk_5_Sink.add('${block_5}:${dotSize_5}');
        //  dot_5_Sink.add(dotSize_5);

          if(!(counter+3>chordDetailsBloc.chordsValueList.length-1)){
            block_6 = chordDetailsBloc.chordsValueList[counter+3];

            if(!(counter+4>chordDetailsBloc.chordsKeyList.length-1)){

              dotSize_6 = chordDetailsBloc.chordsKeyList[counter+4]-chordDetailsBloc.chordsKeyList[counter+3];
            }else{
              dotSize_6 = 0;
            }

          }else{
            block_6 = "";

          }



       //   print("count: $counter");
         /* print("block_0: "+block_0+ " :dots: ${dotSize_0}");
          print("block_1: "+block_1+ " :dots: $dotSize_1");
          print("block_2: "+block_2+ " :dots: $dotSize_2");*/
      //    print("current_block: $currentBlock");
/*          print("block_4: "+block_4+ " :dots: $dotSize_4");
          print("block_5: "+block_5+ " :dots: $dotSize_5");
          print("block_6: "+block_6 + " :dots: $dotSize_6");*/



        if(counter==0){
          delay = chordDetailsBloc.chordsKeyList[counter] * 400;
          //progressTotal = chordsKeyList[counter];
        }else if(!(counter+1>chordDetailsBloc.chordsKeyList.length-1)){
          delay = (chordDetailsBloc.chordsKeyList[counter+1]-
              chordDetailsBloc.chordsKeyList[counter]) *400;

        }


        await new Future.delayed(Duration(milliseconds : delay));

          /*print("#############   ${(chordDetailsBloc.chordsKeyList[counter])} ${chordDetailsBloc.chordsKeyList[counter+1]} "
              " $delay ##################");*/

        counter++;
      }
    }



  }
}