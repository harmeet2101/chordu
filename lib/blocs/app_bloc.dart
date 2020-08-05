

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/blocs/chord_details_bloc.dart';
import 'package:chordu/blocs/you_tube_controller_bloc.dart';
import 'package:chordu/blocs/yt_controller_bloc.dart';

class AppBloc extends Bloc{

  YoutubeControllerBloc _youtubeControllerBloc;
  ChordDetailsBloc _chordDetailsBloc;
  YTPControllerBloc _ytpControllerBloc;



  void setUpYoutubeController(String videoID){
    _youtubeControllerBloc = new YoutubeControllerBloc(videoId: videoID);
  }

  void setUpYoutubeController2(String videoID,ChordDetailsBloc chordDetailsBloc){
    _ytpControllerBloc = new YTPControllerBloc(videoId: videoID,chordDetailsBloc: chordDetailsBloc);
  }

  void setUpChordDetailsController(String id){
    _chordDetailsBloc = new ChordDetailsBloc();
    _chordDetailsBloc.fetchChordDetails(id);
  }

  YoutubeControllerBloc get youtubeControllerBloc =>_youtubeControllerBloc;
  YTPControllerBloc get ytpControllerBloc =>_ytpControllerBloc;
  ChordDetailsBloc get chodDetailsBloc => _chordDetailsBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    _youtubeControllerBloc?.dispose();
    _ytpControllerBloc?.dispose();
    _chordDetailsBloc?.dispose();
  }
}