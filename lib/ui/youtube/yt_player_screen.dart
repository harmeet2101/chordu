import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/blocs/chord_details_bloc.dart';
import 'package:chordu/blocs/you_tube_controller_bloc.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/Status.dart';
import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/ui/progressbars/custom_progress_bar_model.dart';
import 'package:chordu/ui/youtube/song_title.dart';
import 'package:chordu/ui/youtube/yt_app_bar.dart';
import 'package:chordu/ui/youtube/yt_player_controls_widget.dart';
import 'package:chordu/ui/youtube/yt_webview_widget.dart';
import 'package:flutter/material.dart';

class YTPlayerScreen extends StatelessWidget{

  String videoId;
  String thumbnailUrl;
  String songTitle;
  ChordDetailsBloc _chordDetailsBloc ;
  YTPlayerScreen({this.videoId,this.thumbnailUrl,this.songTitle});

  @override
  Widget build(BuildContext context) {

 //   _chordDetailsBloc = new ChordDetailsBloc(chordID: videoId);
    return BlocProvider(
      bloc: YoutubeControllerBloc(videoId: videoId),
      child: Scaffold(
        body: StreamBuilder<Response<ChordDetails>>(builder:(context,snapshot){

          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {

            return Container();
          }
          if(snapshot.hasData){

            switch(snapshot.data.status){

              case Status.LOADING:
                return ProgressBarModel();
              case Status.COMPLETED:
                return Container(
                  color: Color(0xff252525),
                  height: MediaQuery.of(context).size.height,
                  child: Stack(

                    children: <Widget>[

                      CustomScrollView(
                        slivers: <Widget>[

                          YTAppBar(),
                          SliverToBoxAdapter(
                            child: Container(

                              child: Column(
                                children: <Widget>[
                                  SongTitle(heading: 'Chords for ${songTitle}',),
                                  YTWebviewWidget(url: thumbnailUrl,videoId: videoId,),
                                ],
                              ),
                            ),
                          )

                        ],

                      ),
                      Positioned(child: YTPlayerControls(),bottom: 0.0,),
                    ],

                  ),
                );
            //case Status.ERROR:
            }

          }else{
            return new Container();
          }

        },stream: BlocProvider.of<YoutubeControllerBloc>(context).chordDetailsStream),
      ),
    );
  }

}