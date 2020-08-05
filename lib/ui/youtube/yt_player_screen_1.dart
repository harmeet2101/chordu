import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/Status.dart';
import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/ui/progressbars/custom_progress_bar_model.dart';
import 'package:chordu/ui/temp/first_tabview.dart';
import 'package:chordu/ui/youtube/song_title.dart';
import 'package:chordu/ui/youtube/tabviews_widget.dart';
import 'package:chordu/ui/youtube/yt_app_bar.dart';
import 'package:chordu/ui/youtube/yt_player_controls_widget.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../chord_app_details.dart';

class YTPlayerScreen1 extends StatefulWidget{

  String videoId;
  String thumbnailUrl;
  String title;

  YTPlayerScreen1({this.videoId,this.thumbnailUrl,this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTPlayerScreenState();
  }
}

class YTPlayerScreenState extends State<YTPlayerScreen1>{

  AppBloc _appBloc;
  bool _isLoading = true;
  ChordDetails _chordDetails;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _appBloc.setUpChordDetailsController(widget.videoId);
    _appBloc.setUpYoutubeController2(widget.videoId,_appBloc.chodDetailsBloc);


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(


      body: Container(
        color: Color(0xff252525),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: _buildForm(context),

        ),
      ),
    );
  }




  List<Widget> _buildForm(BuildContext context){

    Form form = new Form(child: mainContent());

    var l = new List<Widget>();
    l.add(form);

    if (_isLoading) {
      var modal = new ProgressBarModel();
      l.add(modal);
    }
    return l;
  }

  Widget mainContent(){
    return Scaffold(
      body:  Container(
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
                        SongTitle(heading: 'Chords for ${widget.title}',),
                        ytPlayer(),
                        TabViewsWidget(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: bottomPageDescription(),)
              ],

            ),
            Positioned(child: YTPlayerControls(),bottom: 0.0,),
          ],
        ),
      ),
    );
  }

  Widget ytPlayer(){
    return YoutubePlayer(
      thumbnailUrl: widget.thumbnailUrl,
      controller: _appBloc.ytpControllerBloc.youtubePlayerController,
      onEnded: (value){
        print('ended');
      },
      onReady: (){
        print('player ready');
        setState(() {
          _isLoading = false;
          _appBloc.ytpControllerBloc.isPlayerReady = true;
        });
      },

    );
  }

  Widget bottomPageDescription(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20,0,0),
      child: ChorduAppDetails(),
    );
  }

  Widget temp(){
    return SliverToBoxAdapter(child: StreamBuilder<Response<ChordDetails>>(
        stream: _appBloc.chodDetailsBloc.chordDetailsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }
          if(snapshot.hasData){

            switch(snapshot.data.status){

              case Status.LOADING:{
                return Container();
              }
              case Status.COMPLETED:{
                _chordDetails = snapshot.data.data;
                return Container();
              }
            }

          }else{
            return Container();
          }

        }
    ),);
  }
}