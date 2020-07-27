

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/blocs/you_tube_controller_bloc.dart';

class AppBloc extends Bloc{

  YoutubeControllerBloc _youtubeControllerBloc;
  AppBloc(){

    _youtubeControllerBloc = new YoutubeControllerBloc();
  }

  YoutubeControllerBloc get youtubeControllerBloc =>_youtubeControllerBloc;


  @override
  void dispose() {
    // TODO: implement dispose
    _youtubeControllerBloc?.dispose();
  }
}