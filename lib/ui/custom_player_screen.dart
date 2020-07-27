import 'package:chordu/ui/full_chord_grid.dart';
import 'package:chordu/ui/temp/heading_widget.dart';
import 'package:chordu/ui/temp/youtube_player_webview_widget.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chordu/utils/common_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'chord_app_details.dart';
import 'temp/player_controls_screen.dart';
import 'temp/first_tabview.dart';
import 'temp/second_tabview.dart';
import 'temp/instruments.dart';

import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/rest/chord_info.dart';
import 'package:chordu/ui/pages/diagram_slider_pageview.dart';
import 'package:chordu/ui/pages/transpose_box.dart';
import 'chord_grid_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

class CustomPlayerScreen extends StatelessWidget{

  String videoId;
  String thumbnailUrl;
  String title;

  CustomPlayerScreen({this.videoId,this.thumbnailUrl,this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PlayerScreen(videoId:videoId,thumbnailUrl:thumbnailUrl,title:title);
  }
}



class PlayerScreen extends StatefulWidget{

  String videoId;
  String thumbnailUrl;
  String title;

  PlayerScreen({this.videoId,this.thumbnailUrl,this.title});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayerScreenState();
  }
}

class PlayerScreenState extends State<PlayerScreen>{

  YoutubePlayerController _controller;
  TextEditingController _seekToController;
  PlayerState _playerState;
  bool _isChordTabSelected = false;
  bool _isSimpleChordTabSelected = true;
  bool _isAdvChordTabSelected = false;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _muted = false;
  String timeElapsed = '0:00';
  double _Progresspercentage = 0.0;
  bool _isDiagramTabSelected = true;
  bool isExpanded = false;
  var selectedInstrument = 0;
  List<ChordInfo> chordsInfoList = new List();
  bool _isLoading = true;
  bool _showFirst = true;
  bool _selectGuitar = true,
      _selectPiano=false,
      _selectMandolin = false, _selectUkulele= false;

  Future<ChordDetails> _chordDetails;



  @override
  void initState() {
    // TODO: implement initState
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
    super.initState();
    _chordDetails = getChordDetails(widget.videoId);
  }


  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
    if(_controller.value.isPlaying){

      _isLoading = false;
      timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
      _Progresspercentage = (_controller.value.position.inMilliseconds /
          _controller.metadata.duration.inMilliseconds);

 setState(() {
        _isLoading = false;
        timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
        _Progresspercentage = (_controller.value.position.inMilliseconds /
            _controller.metadata.duration.inMilliseconds);
      });

    }
    if(_playerState==PlayerState.paused){
      print('player paused');
      setState(() {

      });
    }

  }


  Future<ChordDetails> getChordDetails(String _id) async{


    final resp = await http.get('https://chordu.com/flutter_service_chords.php?tid=${_id}');

    if(resp.statusCode==200){

      var res = ChordDetails.fromJson(json.decode(resp.body));

      String chordDataPage = res.chordDataPage;
      String parsedChords =chordDataPage.substring(1,chordDataPage.length-1);

      List<String> ls = parsedChords.split(",");
      Map map = new LinkedHashMap<String,String>();
      var size = 0;

      for(int i =1;i<=ls.length;i++){
        var temp = ls[i-1].split(":");
        var key = temp[0].substring(1,temp[0].length-1);
        map.putIfAbsent(key, () => temp[1].substring(1,temp[1].length-1));
        size = int.parse(key);
      }
      setState(() {
        for(int i=1;i<=(size+16);i++){
          if(map.containsKey("$i")){
            chordsInfoList.add(new ChordInfo(location: i,text:map["$i"],isActive: true ));
          }else{
            chordsInfoList.add(new ChordInfo(location: i,text:'',isActive: false ));
          }
        }
      });

      return res;
    }
    else
      throw new Exception('error ocurred');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return InheritedPlayerScreen(child: Scaffold(
     body: Container(
       color: Color(0xff252525),
       height: MediaQuery.of(context).size.height,
       child: Stack(
         children: <Widget>[

           CustomScrollView(

             slivers: <Widget>[
               SliverAppBar(

                 flexibleSpace: Container(
                   child: FlexibleSpaceBar(
                     title: Text(AppConstants.APP_NAME),
                   ),
                   decoration: BoxDecoration(

                     gradient: LinearGradient(colors: [Color(0xff0D4947),Colors.black87],stops: [0.4,1],
                         begin:Alignment.topLeft,end: Alignment.bottomLeft
                     ),
                   ),
                 ),
                 leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:(){

                   Navigator.pop(context);
                 }
                 ),
                 floating: true,
                 actions: <Widget>[

                   InkWell(

                     onTap: (){

                     },
                     child: Container(
                       width: 55,
                       child: Icon(Icons.account_circle,size: 40,),
                     ),
                   )
                 ],
               ),
               SliverToBoxAdapter(child:
                 Column(
                   children: <Widget>[
                     HeadingWidget(heading: 'Chords for ${widget.title}',),
                     YouTubeWebViewWidget(url: widget.thumbnailUrl,),
                     FirstTabView(),
                     _isDiagramTabSelected?Padding(
                       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                       child: DiagramSliderWidget(selectedInstrumentType: selectedInstrument,chordsInfoList: chordsInfoList,),
                     ):
                     FullChordGridView(chordsInfoList:chordsInfoList),
                     _isDiagramTabSelected?Padding(
                       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                       child: SecondTabView(),
                     ):Container(),
                     _isDiagramTabSelected?Padding(
                       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                       child: InstrumentWidget(),
                     ):Container(),
                     _isDiagramTabSelected?TransposeWidget(showFirst: _showFirst,isTuneDialog: false,)
                         :Container(),
                     _isDiagramTabSelected?Padding(
                       padding: const EdgeInsets.fromLTRB(0, 10, 0,10),
                       child: ChordsGridWidget(chordsInfoList:chordsInfoList,
                         isExpanded: false,type: 'Second',),
                     ):Container(),
                   ],
                 ),),
               SliverToBoxAdapter(child: Padding(
                 padding: const EdgeInsets.fromLTRB(0,20,0,0),
                 child: ChorduAppDetails(),
               ),)
             ],
           ),
           Positioned(child: PlayerControls(),bottom: 0.0,),
         ],
       ),
     ),

   ), data: this);
  }


  static PlayerScreenState of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<InheritedPlayerScreen>().data;
  }



  ////////////////////////////////////////////////////////////
  //                                                        //
  //                                                        //
  //               getters and setters                      //
  //                                                        //
  //                                                        //
  ////////////////////////////////////////////////////////////

  YoutubePlayerController get controller => _controller;
  set isDiagramTabSelected(bool value) {
    _isDiagramTabSelected = value;
  }

  TextEditingController get seekToController => _seekToController;

  PlayerState get playerState => _playerState;

  set controller(YoutubePlayerController value) {
    _controller = value;
  }

  YoutubeMetaData get videoMetaData => _videoMetaData;

  bool get isPlayerReady => _isPlayerReady;

  set seekToController(TextEditingController value) {
    _seekToController = value;
  }

  set playerState(PlayerState value) {
    _playerState = value;
  }

  set videoMetaData(YoutubeMetaData value) {
    _videoMetaData = value;
  }

  set isPlayerReady(bool value) {
    _isPlayerReady = value;
  }

  bool get isChordTabSelected => _isChordTabSelected;

  bool get isSimpleChordTabSelected => _isSimpleChordTabSelected;

  bool get isAdvChordTabSelected => _isAdvChordTabSelected;

  set isChordTabSelected(bool value) {
    _isChordTabSelected = value;
  }

  set isSimpleChordTabSelected(bool value) {
    _isSimpleChordTabSelected = value;
  }

  set isAdvChordTabSelected(bool value) {
    _isAdvChordTabSelected = value;
  }

  bool get showFirst => _showFirst;

  set showFirst(bool value) {
    _showFirst = value;
  }

  get selectPiano => _selectPiano;

  set selectPiano(value) {
    _selectPiano = value;
  }

  get selectMandolin => _selectMandolin;

  set selectMandolin(value) {
    _selectMandolin = value;
  }

  get selectUkulele => _selectUkulele;

  set selectUkulele(value) {
    _selectUkulele = value;
  }

  bool get isDiagramTabSelected => _isDiagramTabSelected;

  double get Progresspercentage => _Progresspercentage;

  bool get muted => _muted;

  set muted(bool value) {
    _muted = value;
  }
  bool get selectGuitar => _selectGuitar;

  set selectGuitar(bool value) {
    _selectGuitar = value;
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }


  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _seekToController.dispose();
    super.dispose();
  }

}


class InheritedPlayerScreen extends InheritedWidget{

  final PlayerScreenState data;

  InheritedPlayerScreen({Key key,@required Widget child,@required this.data}):super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

