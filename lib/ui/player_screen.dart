
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/rest/chord_info.dart';
import 'package:chordu/ui/dialogs/tune_cords_dialog.dart';
import 'package:chordu/ui/full_chord_grid.dart';
import 'package:chordu/ui/pages/diagram_slider_pageview.dart';
import 'package:chordu/ui/pages/transpose_box.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:chordu/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'chord_app_details.dart';
import 'chord_grid_widget.dart';
import 'dialogs/login_dialog.dart';
import 'progressbars/custom_progress_bar_model.dart';


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
class PlayerScreenState extends State<PlayerScreen> {

  YoutubePlayerController _controller;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String timeElapsed = '0:00';
  double _percentage = 0.0;
  double _Progresspercentage = 0.0;
  bool selectGuitar = true,selectPiano=false, selectMandolin = false,
  selectUkulele= false;
  bool isExpanded = false;
  var selectedInstrument = 0;
  Future<ChordDetails> _chordDetails;
  List<ChordInfo> chordsInfoList = new List();
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isDiagramTabSelected = true;
  bool _isChordTabSelected = false;
  bool _isSimpleChordTabSelected = true;
  bool _isAdvChordTabSelected = false;
  bool _showFirst = true;
  var chordsKeyList = new List<int>();
  var chordsValueList = new List<String>();
  String block_0='',block_1='',block_2='',
      currentBlock='',block_4='',block_5='',block_6='';
  int dotSize_6=0,dotSize_5=0,dotSize_4=0,dotSize_2=0,dotSize_1=0,dotSize_0=0;
  int currentKey =0;
  int progressTotal =0;
  double progressPercentage =0.0;
  bool isFirstTime=true;
  @override
  void initState(){
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
      /*setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });*/

      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;

     // print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

    //  setTimeInterval();
    }
    if(_controller.value.isPlaying){

      _isLoading = false;
      _isPlaying = true;
      timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
      _Progresspercentage = (_controller.value.position.inMilliseconds /
          _controller.metadata.duration.inMilliseconds);
     /* setState(() {
        _isLoading = false;
        _isPlaying = true;
        timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
        _Progresspercentage = (_controller.value.position.inMilliseconds /
            _controller.metadata.duration.inMilliseconds);

      });*/

      if(isFirstTime){
        /*setState(() {
          isFirstTime = false;
          temp01();
        });*/
        isFirstTime = false;
        temp01();
      }
    // await temp01();

    }
    if(!_controller.value.isPlaying){

      _isPlaying = false;
      isFirstTime = true;
     // print('Not playing');
     /* setState(() {
        _isPlaying = false;
        isFirstTime = true;
      });*/
    }
  }
  int counter=0;
  void temp01()async{

    int delay=0;

      if(chordsKeyList.isNotEmpty && chordsValueList.isNotEmpty){

        while(counter < chordsValueList.length && _isPlaying){

         //  progressTotal =0;
        //  progressPercentage =0.0;
          setState(() {
            currentBlock = chordsValueList[counter];
            currentKey = chordsKeyList[counter];
            if((counter-3)<0){
              block_0 = "";
              dotSize_0=0;
            }else{
              block_0 = chordsValueList[counter-3];
              dotSize_0 = chordsKeyList[counter-2] - chordsKeyList[counter-3];
            }
            if((counter-2)<0){
              block_1 = "";
              dotSize_1=0;
            }else{
              block_1 = chordsValueList[counter-2];
              dotSize_1 = chordsKeyList[counter-1]-chordsKeyList[counter-2];
            }
            if((counter-1)<0){
              block_2 = "";
              dotSize_2=0;
            }else{
              block_2 = chordsValueList[counter-1];
              dotSize_2 = chordsKeyList[counter]-chordsKeyList[counter-1];
            }

            if(!(counter+1>chordsValueList.length-1)){
              block_4 = chordsValueList[counter+1];

              if(!(counter+2>chordsKeyList.length-1)){

                dotSize_4 = chordsKeyList[counter+2]-chordsKeyList[counter+1];
              }else{
                dotSize_4 = 0;
              }

            }else{
              block_4 = "";
            }
            if(!(counter+2>chordsValueList.length-1)){
              block_5 = chordsValueList[counter+2];

              if(!(counter+3>chordsKeyList.length-1)){

                dotSize_5 = chordsKeyList[counter+3]-chordsKeyList[counter+2];
              }else{
                dotSize_5 = 0;
              }
            }else{
              block_5 = "";
            }
            if(!(counter+3>chordsValueList.length-1)){
              block_6 = chordsValueList[counter+3];

              if(!(counter+4>chordsKeyList.length-1)){

                dotSize_6 = chordsKeyList[counter+4]-chordsKeyList[counter+3];
              }else{
                dotSize_6 = 0;
              }

            }else{
              block_6 = "";

            }
          });

      /*    print("count: $counter");
          print("block_0: "+block_0+ " :dots: ${dotSize_0}");
          print("block_1: "+block_1+ " :dots: $dotSize_1");
          print("block_2: "+block_2+ " :dots: $dotSize_2");
          print("current_block: $currentBlock");
          print("block_4: "+block_4+ " :dots: $dotSize_4");
          print("block_5: "+block_5+ " :dots: $dotSize_5");
          print("block_6: "+block_6 + " :dots: $dotSize_6");*/



          if(counter==0){
            delay = chordsKeyList[counter] * 370;
            //progressTotal = chordsKeyList[counter];
          }else if(!(counter+1>chordsKeyList.length-1)){
            delay = (chordsKeyList[counter+1]-chordsKeyList[counter]) *370;
          //  progressTotal = (chordsKeyList[counter+1]-chordsKeyList[counter]);
          }

          /*progressPercentage =  (1/progressTotal);
          while(progressPercentage<1.1){

            print(" progress: $progressPercentage");
            await new Future.delayed(Duration(milliseconds : (progressPercentage * 10).round()));
            setState(() {
              progressPercentage +=(1/progressTotal);
            //
            });

          }*/

          await new Future.delayed(Duration(milliseconds : delay));

        //  print("############# $delay ##################");

          counter++;
        }
      }



  }

  var testCount=0;
  void setTimeInterval()async{

    //var currentBlock = 0;
    var playerCurrentTime = (_controller.value.position.inMilliseconds)/0.4;
    var currentBlock = playerCurrentTime.ceil() + 1;
    await new Future.delayed(const Duration(seconds : 5));
    testCount++;
    print("#### $testCount #####: current time:  ${playerCurrentTime} "
        "currentBlock: ${currentBlock}");

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

    Form form = new Form(child: Stack(
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
            SliverToBoxAdapter(
              child:Container(
                child: Column(
                  children: <Widget>[
                    getHeading('Chords for ${widget.title}'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height*0.5,
                        child:  YoutubePlayer(
                          thumbnailUrl: widget.thumbnailUrl,
                          controller: _controller,
                          onEnded: (value){
                            print('ended');
                            _playerState=PlayerState.ended;
                            setState(() {

                              _controller.pause();
                            });
                          },
                          onReady: (){
                            setState(() {
                              print('player ready');
                              _isPlayerReady = true;
                            });
                          },

                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TabView01(context),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0, 10, 5),
                          child: Text('$timeElapsed',style: TextStyle(fontSize: 26,
                              color: Colors.white38),),
                        ),
                      ],
                    ),

                    _isDiagramTabSelected?Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: DiagramSliderWidget(selectedInstrumentType: selectedInstrument,
                        chordsInfoList: chordsInfoList,counter: counter,),
                    ):
                    new FullChordGridView(chordsInfoList: chordsInfoList,
                      counter: counter,currentblock: currentBlock,
                      currentKey: currentKey,),

                    _isDiagramTabSelected?Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TabView02(context),
                    ):Container(),
                    _isDiagramTabSelected?Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: instrumentRow(),
                    ):Container(),
                    _isDiagramTabSelected?TransposeWidget(showFirst: _showFirst,
                      isTuneDialog: false,)
                        :Container(),
                    _isDiagramTabSelected?Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0,10),
                      child: ChordsGridWidget(chordsInfoList:chordsInfoList,
                        isExpanded: false,type: '',),
                    ):Container(),

                  ],
                ),
              ) ,
            ),
            SliverToBoxAdapter(child: bottomPageDescription(),)
          ],

        ),
        Positioned(child: playerControls(),bottom: 0.0,),
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
  Widget getHeading(String heading){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(

        children: <Widget>[

          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Icon(Icons.music_note,
            color: Color(0xff058377),size: 25,),),
          Expanded(child: Text(heading,style: TextStyle(color: Colors.white60,fontSize: 18,fontFamily: 'Play'),
            softWrap: true,maxLines: 2,)
          ,flex: 1,
          )
        ],
      ),
    );
  }

  Widget instrumentRow(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Guitar',selectGuitar),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: instrumentItem('Piano',selectPiano),
        ),
        instrumentItem('Ukulele',selectUkulele),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: instrumentItem('Mandolin',selectMandolin),
        ),

      ],
    );
  }
  
  Widget instrumentItem(String instrumentName,bool _defaultSelection){
    
    return Container(

      decoration: BoxDecoration(
          color: _defaultSelection?Color(0xff1F1F1F):Color(0xff505152),
          border: Border.all(color:  _defaultSelection?Colors.white60:Colors.grey,width: 0.8),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: InkWell(
        onTap: (){

          setState(() {
            if(instrumentName=='Guitar'){
              selectGuitar = true;
              selectPiano = false;
              selectUkulele = false;
              selectMandolin = false;
              selectedInstrument = 0;
            }else if(instrumentName == 'Piano'){
              selectGuitar = false;
              selectPiano = true;
              selectUkulele = false;
              selectMandolin = false;
              selectedInstrument = 1;
            }else if(instrumentName == 'Ukulele'){
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = true;
              selectMandolin = false;
              selectedInstrument = 2;
            }else{
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = false;
              selectMandolin = true;
              selectedInstrument = 3;
            }
          });

        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(instrumentName,style: TextStyle(fontSize: 16,color: Colors.white),),
        ),
      ),
    );
  }
  
  Widget playerControls(){

    return Container(

      width: MediaQuery.of(context).size.width,

      color: Colors.black87,

      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  cordsContainer(block_1,60,60,false,dotSize_1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer(block_2,60,60,false,dotSize_2),
                  ),
                  Expanded(
                    child:currentCordContainer(currentBlock,80,60,true,0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer(block_4,60,60,false,dotSize_4),
                  ),
                  cordsContainer(block_5,60,60,false,dotSize_5),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 2,
            child: LinearProgressIndicator(
            value: _Progresspercentage,
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff01AE6D)),  // 068C59
            backgroundColor: Colors.black87,
          ),),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff222727),Color(0xff252B2C),Color(0xff1E2121)],
                  begin:Alignment.topCenter ,end: Alignment.bottomCenter,stops: [0.2,0.5,0.9])
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                    child: Center(child: IconButton(icon: Icon(Icons.favorite,color: Color(0xffA17465),size: 36,),)),
                  ),),
                onTap: (){
                  showDialog(context: context,builder: (context){

                    return AlertDialog(
                      actions: <Widget>[

                      ],content: LoginDialog(),
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.only(left: 5,right: 5),
                    );
                  });
                },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.share,color: Color(0xffA5A5A5),size: 36,),
                        )),
                  ),),
                onTap: (){

                },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_rewind,color: Color(0xffA5A5A5),size: 36,),
                        ),),
                  )),onTap: (){
                  _controller.seekTo(Duration(seconds: (_controller.value.position.inSeconds - 10)));
                },
                ),
                InkWell(
                  child: Container(child:Align(child:
                  IconButton(icon: Icon(_controller.value.isPlaying?Icons.pause_circle_filled:Icons.play_circle_filled,
                    color: Color(0xffA5A5A5),size: 36,),
                    alignment: Alignment.topLeft,),),
                    ),onTap: _isPlayerReady?(){
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  setState(() {});

                }:null,
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_forward ,color: Color(0xffA5A5A5),size: 36,),
                        )),
                  )),onTap: _isPlayerReady?(){

                    _controller.seekTo(Duration(seconds: (_controller.value.position.inSeconds + 10)));
                }:null,
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(_muted?Icons.volume_off:Icons.volume_up,
                      color: Color(0xffA5A5A5),size: 36,),
                        )),
                  ),),onTap: _isPlayerReady?(){

                  _muted
                      ? _controller.unMute()
                      : _controller.mute();
                  setState(() {
                    _muted = !_muted;
                  });
                }:null,
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    child: Center(child: IconButton(icon: Icon(Icons.equalizer,color: Color(0xffBBD7D5),size: 36,),
                        )),
                  ),),
                  onTap: (){
                    showDialog(context: context,builder: (context){

                      return AlertDialog(
                        actions: <Widget>[

                        ],content: TuneChordsDialog(),
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.only(left: 5,right: 5),
                      );
                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget TabView01(BuildContext context) {
    // TODO: implement build
    return Row(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        InkWell(
          onTap: (){

              setState(() {
                _isDiagramTabSelected = true;
                _isChordTabSelected = false;
              });
          },
          child:tab01('Diagram Slider'),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0,0, 0),
          child: InkWell(
            onTap: (){
              setState(() {
                _isDiagramTabSelected = false;
                _isChordTabSelected = true;
              });
            },
            child: tab03('Chord Sheet'),
          ),
        ),


      ],
    );
  }
  Widget tab01(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            _isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):
            new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: _isDiagramTabSelected?Colors.white70:Colors.white),),
            ),
            _isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container()
          ],
        ),
        decoration: BoxDecoration(

            color: _isDiagramTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0),


        ));
  }
  Widget tab03(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            _isDiagramTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: _isChordTabSelected?Colors.white70:Colors.white),),
            ),
            _isChordTabSelected?Container(width:80,height: 2,color:Colors.green,):new Container(),
          ],
        ),
        decoration: BoxDecoration(

            color: _isChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }

  Widget TabView02(BuildContext context) {
    // TODO: implement build
    return Row(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        InkWell(
          onTap: (){

            setState(() {
              _isSimpleChordTabSelected = true;
              _isAdvChordTabSelected = false;
              _showFirst = false;
              animateDelay();

            });
          },
          child:tab02('Simple Chords'),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0,0, 0),
          child: InkWell(
            onTap: (){
              setState(() {
                _isSimpleChordTabSelected = false;
                _isAdvChordTabSelected = true;

                _showFirst = false;
                animateDelay();

              });
            },
            child: tab04('Advance Chords'),
          ),
        ),


      ],
    );
  }
  Widget tab02(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: _isSimpleChordTabSelected?Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:_isSimpleChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: _isSimpleChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
  }
  Widget tab04(String text){
    return Container(
      //color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text,style: TextStyle(fontSize: 18,
                  color: _isAdvChordTabSelected?Colors.white70:Colors.white),),
            ),
            Container(width:80,height: 2,color:_isAdvChordTabSelected?Colors.white:Colors.green,)
          ],
        ),
        decoration: BoxDecoration(

            color: _isAdvChordTabSelected?Color(0xff202020):Color(0xff004F59),
            shape: BoxShape.rectangle,
            borderRadius:BorderRadius.circular(6.0)
        ));
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

  Widget cordsContainer(String text,double _width,double _height,bool currentBlock,int count) {

    return  Container(
        width: _width,
        height: _height,
        child:
        Column(children: <Widget>[
          Spacer(flex: 1,),
          Text(text,style: TextStyle(fontSize: 24,color: Color(0xffD48A31)),),
          Spacer(flex: 1,),
         !currentBlock?Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
            child: chordDotsRowWidget(count),
          ):Container(),

        ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xff222727),
            border: Border.all(width: 0.8,color: Colors.white60),
            borderRadius: BorderRadius.circular(10.0)
        ),
      );
  }
  Widget currentCordContainer(String text,double _width,double _height,bool currentBlock,int count) {

    return  Container(
        width: _width,
        height: _height,
        child:
        Stack(
          children: <Widget>[

            Container(

              height: _height,
              child: LinearProgressIndicator(
                value: progressPercentage,
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff058377)),  // 068C59
                backgroundColor: Colors.black87,
              ),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                    border: Border.all(width: 0.8,color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0)
                )
            ),
            Align(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Spacer(flex: 1,),
                Text(text,style: TextStyle(fontSize: 24,color: Color(0xffD48A31)),),
                Spacer(flex: 1,),

              ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
            )
          ],
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xff222727),
            border: Border.all(width: 0.8,color: Colors.white60),
            borderRadius: BorderRadius.circular(10.0)
        ),
      );
  }

  Widget chordDotsRowWidget(int count){
    if(count>0){
      return
         Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: chordsDotsWidget(count)

      );
    }else{
      return Container();
    }
  }

  List<Widget> chordsDotsWidget(int count){

    var ls = new List<Widget>();
    for(int i=0;i<count;i++)
    ls.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child:Container(height: 2.0,color: Colors.white),
      ),
    ));
    return ls;
  }


  Widget bottomPageDescription(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20,0,0),
      child: ChorduAppDetails(),
    );
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
        chordsKeyList.add(int.parse(key));
        var value = temp[1].substring(1,temp[1].length-1);
        chordsValueList.add(value);
        map.putIfAbsent(key, () => value);
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


  animateDelay()async{

    var _duration = Duration(milliseconds: 5000);
    new Timer(_duration, temp );
  }

  void temp(){

    setState(() {
      _showFirst = true;
    });
  }

}

