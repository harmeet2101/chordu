import 'package:chordu/blocs/app_bloc.dart';
import 'package:chordu/blocs/bloc_provider.dart';
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

class YTMainScreen extends StatefulWidget{

  String videoId;
  String thumbnailUrl;
  String title;

  YTMainScreen({this.videoId,this.thumbnailUrl,this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YTMainScreenState();
  }
}

class YTMainScreenState extends State<YTMainScreen>{

  AppBloc _appBloc;
  ChordDetails _chordDetails;
  YoutubePlayerController _controller;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _muted = false;
  bool _isLoading = true;
  String timeElapsed = '0:00';
  double _Progresspercentage = 0.0;

  YoutubePlayerController get controller => _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    _appBloc.setUpChordDetailsController(widget.videoId);

    _controller = YoutubePlayerController
      (initialVideoId: widget.videoId,
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
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  callback() {
    setState(() {
    //  abc = newAbc;
      print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    });
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {

      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
    }
    if(_controller.value.isPlaying){

      _isLoading = false;
      timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
      _Progresspercentage = (_controller.value.position.inMilliseconds /
          _controller.metadata.duration.inMilliseconds);

    }
    if(_playerState==PlayerState.paused){
      print('player paused');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
      return InheritedPlayerScreen(child: mainContent(), data: this);
  }

  static YTMainScreenState of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<InheritedPlayerScreen>().data;
  }


  List<Widget> _buildForm(BuildContext context){

    Form form = new Form(child: Stack(
      children: <Widget>[

      ],

    ));

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
                SliverToBoxAdapter(child: StreamBuilder<Response<ChordDetails>>(
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
                ),),
                SliverToBoxAdapter(
                  child: Container(

                    child: Column(
                      children: <Widget>[
                        SongTitle(heading: 'Chords for ${widget.title}',),
                        YTWebviewWidget(url: widget.thumbnailUrl,
                      videoId: widget.videoId,callback: callback,),
                      ],
                    ),
                  ),
                )
              ],

            ),
        Positioned(child: YTPlayerControls(),bottom: 0.0,),
          ],
        ),
      ),
    );
  }

}


class InheritedPlayerScreen extends InheritedWidget{

  final YTMainScreenState data;

  InheritedPlayerScreen({Key key,@required Widget child,@required this.data}):super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}