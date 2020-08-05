import 'package:chordu/blocs/app_bloc.dart';
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
import 'package:chordu/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayerScreen extends StatefulWidget{

  String videoId;
  String thumbnailUrl;
  String songTitle;
  ChordDetailsBloc _chordDetailsBloc ;
  YTPlayerScreen({this.videoId,this.thumbnailUrl,this.songTitle});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTPlayerScreenState();
  }


}
class YTPlayerScreenState extends State<YTPlayerScreen>{

  AppBloc _appBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _appBloc.setUpChordDetailsController(widget.videoId);
    _appBloc.setUpYoutubeController(widget.videoId);



  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
        children: <Widget>[
          StreamBuilder<Response<ChordDetails>>(
            stream: _appBloc.chodDetailsBloc.chordDetailsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Container();
              }
              if(snapshot.hasData){

                switch(snapshot.data.status){

                  case Status.LOADING:{
                    // print('loading block');
                    return ProgressBarModel();
                  }
                  case Status.COMPLETED:{
                    //  print('completed block');
                     return Container(
                      color: Color(0xff252525),
                      height: MediaQuery.of(context).size.height,
                      child: mainContent(),
                    );
                  }
                }

              }else{
                return Container();
              }

            }
          ),
          StreamBuilder<Response<String>>(builder:(context,snapshot){

            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Container();
            }
            if(snapshot.hasData){

              switch(snapshot.data.status){

                case Status.LOADING:{
                  // print('loading block');
                  return ProgressBarModel();
                }
                case Status.COMPLETED:{
                //  print('completed block');
                  return Container();
                }
              }

            }else{
               return Container();
            }
          },stream: BlocProvider.of<AppBloc>(context).
          youtubeControllerBloc.youtubeControllersStream),
     ],
     ));


  }

  Widget mainContent(){
    return Stack(

      children: <Widget>[

        CustomScrollView(
          slivers: <Widget>[

            YTAppBar(),
            SliverToBoxAdapter(
              child: Container(

                child: Column(
                  children: <Widget>[
                    SongTitle(heading: 'Chords for ${widget.songTitle}',),
                    YTWebviewWidget(url: widget.thumbnailUrl,
                      videoId: widget.videoId,),
                  ],
                ),
              ),
            )
          ],

        ),
        Positioned(child: YTPlayerControls(),bottom: 0.0,),
      ],
    );
  }
}