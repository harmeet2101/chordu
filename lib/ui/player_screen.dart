
import 'dart:collection';
import 'dart:convert';

import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/rest/chord_info.dart';
import 'package:chordu/ui/chords_painter.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:chordu/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
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
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String timeElapsed = '0:00';
  double _percentage = 0.0;
  bool selectGuitar = true,selectPiano=false,selectMandolin = false,
      selectUkulele= false;
  bool transposeSwitch = true;
  bool isExpanded = false;
  Future<ChordDetails> _chordDetails;
  List<ChordInfo> chordsInfoList = new List();

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
            enableCaption: true
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

      setState(() {
        timeElapsed = CommonUtils.convertTime(_controller.value.position.inMilliseconds);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text(AppConstants.APP_NAME),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:(){

          Navigator.pop(context);
        }
        ),
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
      body: Container(
        color: Colors.black87,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[


              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[

                      getHeading('Chords for ${widget.title}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height*0.5,
                          child: YoutubePlayer(
                            aspectRatio: 16/9,
                            thumbnailUrl: widget.thumbnailUrl,
                            progressColors: ProgressBarColors(

                                playedColor: Colors.blue,
                                handleColor:  Colors.blueAccent
                            ),
                            controller: _controller,
                            onEnded: (value){
                              print('ended');
                              _playerState=PlayerState.ended;
                              setState(() {

                                _controller.pause();
                              });
                            },
                            onReady: (){
                              print('player ready');
                              _isPlayerReady = true;
                            },

                          ),
                        ),
                      ),
                      Text('$timeElapsed',style: TextStyle(fontSize: 18,color: Colors.white),),
                      DefaultTabController(length: 2, child: Container(

                        height: 300,
                        child: Scaffold(

                          backgroundColor:Colors.black87,
                          appBar: TabBar(tabs:
                          [
                            Tab(child: Container(
                              //color: Theme.of(context).primaryColor,
                              child: Align(alignment:Alignment.center,
                                  child: Text('Diagram Slider',style: TextStyle(fontSize: 18,color: Colors.white),)),
                            ),),
                            Tab(child: Align(alignment: Alignment.center,
                                child: Text('Chord Sheet',style: TextStyle(fontSize: 18,color: Colors.white),)),)
                          ],/*indicatorColor: Theme.of(context).primaryColor,*/indicatorSize: TabBarIndicatorSize.label,
                          ),
                          body: TabBarView(
                            children: [
                              getDiagramSliderItems(context),
                              Text('Under Dev',style: TextStyle(fontSize: 18,color: Colors.white)),
                            ],
                          ),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8,0,8),
                        child: DefaultTabController(length: 2, child: Container(

                          height: 300,
                          child: Scaffold(

                            backgroundColor:Colors.black87,
                            appBar: TabBar(tabs:
                            [
                              Tab(child: Container(
                               // color: Theme.of(context).primaryColor,
                                child: Align(alignment:Alignment.center,
                                    child: Text('Simple Chords',style: TextStyle(fontSize: 18,color: Colors.white),)),
                              ),),
                              Tab(child: Align(alignment: Alignment.center,
                                  child: Text('Advance Chords',style: TextStyle(fontSize: 18,color: Colors.white),)),)
                            ],/*indicatorColor: Theme.of(context).primaryColor,*/indicatorSize: TabBarIndicatorSize.label,
                            ),
                            body: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                  child: instrumentRow(),
                                ),
                                Text('Under Dev',style: TextStyle(fontSize: 18,color: Colors.white)),
                              ],
                            ),
                          ),
                        )),
                      ),
                      transposeSettingBox(context),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,10),child:
                      Container(
                        width: MediaQuery.of(context).size.width-20,
                        height: !isExpanded?250:500,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.white60,width: 0.5)
                        ),

                        child: Stack(
                          children: <Widget>[
                            gridView(),
                            !isExpanded?Positioned(child:InkWell(
                              child: Container(

                                  width: MediaQuery.of(context).size.width-20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text('Read More',style: TextStyle(fontSize: 22,color: Colors.tealAccent),),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                          top: BorderSide(width: 1.5,color: Colors.green)
                                      )
                                  )

                              ),
                              onTap: (){

                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                            ),
                                bottom: 0.0):Container()
                          ],
                        ),
                      ),)
                    ],
                  ),
                ),
              ),

           /* Positioned(child: playerControls(),bottom: 0.0,),*/
          ],
        ),
      ),
    );

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

  Widget getDiagramSliderItems(BuildContext buildContext){

    return ListView.builder(itemBuilder: (buildContext,index)=>Container(

      width: 200,
      height: 100,
      color: Colors.purpleAccent,
      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),child:
        Material(
          elevation: 10,
          color: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Center(child: Text('Item $index',style: TextStyle(color: Colors.white,fontSize: 20),)),
        ),),

    ),scrollDirection: Axis.horizontal,itemCount: 20,);
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
          color: _defaultSelection?Colors.black:Colors.grey,
          border: Border.all(color:  _defaultSelection?Colors.white:Colors.grey,width: 0.8),
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
            }else if(instrumentName == 'Piano'){
              selectGuitar = false;
              selectPiano = true;
              selectUkulele = false;
              selectMandolin = false;
            }else if(instrumentName == 'Ukulele'){
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = true;
              selectMandolin = false;
            }else{
              selectGuitar = false;
              selectPiano = false;
              selectUkulele = false;
              selectMandolin = true;
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

      color: Colors.black54,

      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  cordsContainer('F',60,60),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer('Am',60,60),
                  ),
                  Expanded(
                    child:cordsContainer('C',80,60),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: cordsContainer('Bb',60,60),
                  ),
                  cordsContainer('Fm',60,60),
                ],
              ),
            ),
          ),
          Container(
            color: Color(0xff058377),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                    child: Center(child: IconButton(icon: Icon(Icons.favorite,color: Colors.redAccent,size: 36,),)),
                  ),),
                onTap: (){

                    setState(() {

                      _percentage +=10;
                      if(_percentage>100.00){
                        _percentage = 0.0;
                      }
                    });
                },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(Icons.share,color: Colors.grey,size: 36,),
                        )),
                  ),),
                onTap: (){

                },),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(child: IconButton(icon: Icon(Icons.fast_rewind,color: Colors.grey,size: 36,),
                        ),),
                  )),onTap: (){
                  _controller.seekTo(Duration(seconds: (_controller.value.position.inSeconds - 10)));
                },
                ),
                InkWell(
                  child: Container(child:Align(child: IconButton(icon: Icon(_controller.value.isPlaying?Icons.pause_circle_filled:Icons.play_circle_filled,
                    color: Colors.grey,size: 36,),
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
                    child: Center(child: IconButton(icon: Icon(Icons.fast_forward ,color: Colors.grey,size: 36,),
                        )),
                  )),onTap: _isPlayerReady?(){

                    _controller.seekTo(Duration(seconds: (_controller.value.position.inSeconds + 10)));
                }:null,
                ),
                InkWell(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: IconButton(icon: Icon(_muted?Icons.volume_off:Icons.volume_up,
                      color: Colors.grey,size: 36,),
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
                    child: Center(child: IconButton(icon: Icon(Icons.equalizer,color: Colors.white,size: 36,),
                        )),
                  ),),
                  onTap: (){},
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget transposeSettingBox(BuildContext buildContext){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        width: MediaQuery.of(buildContext).size.width,

        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Transpose',style: TextStyle(fontSize: 22,color: Colors.grey[400]),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text('Off',style: TextStyle(fontSize: 22,color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        width: 30,
                        child: Center(
                          child: Icon(Icons.add,color: Colors.black,),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      width: 30,
                      child: Center(
                        child: Icon(Icons.remove,color: Colors.black,),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,0),
              child: Text('Am C F A Bb Fm Dm',style: TextStyle(fontSize: 18,color: Colors.greenAccent),),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoSwitch(value: transposeSwitch, onChanged: (bool value){
                    setState(() {
                          transposeSwitch = value;
                    });
                  },activeColor: Color(0xff058377),trackColor: Colors.grey[400],),
                  Text('Save Tuning',style: TextStyle(fontSize: 18,color: Colors.cyanAccent),)
                ],
              )
              ,),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,0),
              child: Text('Use Flats, Sharpes or Both ?',style: TextStyle(fontSize: 18,color: Colors.grey[400]),),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0,10),child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  transposeCordsContainer('b', 40, 40,true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0, 10, 0),
                    child: transposeCordsContainer('#', 40, 40,false),
                  ),
                  transposeCordsContainer('#b', 40, 40,false),
                ],
              ),),

          ],
        ),

        decoration: BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
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

  Widget cordsContainer(String text,double _width,double _height) {

    return  Container(
        width: _width,
        height: _height,
        child:
        Center(child: Text(text,style: TextStyle(fontSize: 24,color: Colors.yellow),),),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black54,
            border: Border.all(width: 1,color: Colors.white),
            borderRadius: BorderRadius.circular(10.0)
        ),
      );
  }
  Widget transposeCordsContainer(String text,double _width,double _height,bool isActive) {

    return  InkWell(
      onTap: (){

      },
      child: Container(
          width: _width,
          height: _height,
          child:
          Center(child: Text(text,style: TextStyle(fontSize: 24,color: isActive?Colors.white:Colors.grey[400]),),),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: isActive?Color(0xff058377):Colors.white,
              border: Border.all(width: 1,color: Colors.white),
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
    );
  }


  Widget gridView(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: GridView.count(
          primary: false,
          physics: !isExpanded?NeverScrollableScrollPhysics():ClampingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 6,
          scrollDirection: Axis.vertical,
          children: getChordsList(),
        )
    );
  }

  List getChordsList(){

    List<Widget> wl = new List();

    for(int i =1;i<=chordsInfoList.length;i++){

        wl.add(CordsContainer(chordsInfoList[i-1].text,chordsInfoList[i-1].isActive));
    }
    return wl;
  }

  Widget CordsContainer(String text,bool isActive) {

    return  InkWell(
      onTap: (){

      },
      child: Container(
        width: 50,
        height: 50,
        child:
        Center(child: Text(text,style: TextStyle(fontSize: 20,color: isActive?Colors.yellow:Colors.black54),),),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isActive?Colors.grey[600]:Colors.black54,
            border: Border.all(width: 1,color: isActive?Colors.white38:Colors.black54),
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
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
        map.putIfAbsent(key, () => temp[1].substring(1,temp[1].length-1));
        size = int.parse(key);
      }


      setState(() {
        for(int i=1;i<=(size+16);i++){


          if(map.containsKey("$i")){
         //   print('{ bloc: $i, value: ${map["$i"]}');
            chordsInfoList.add(new ChordInfo(location: i,text:map["$i"],isActive: true ));
          }else{
           // print('{ bloc: $i, value: NA');
            chordsInfoList.add(new ChordInfo(location: i,text:'',isActive: false ));
          }
        }
      });

      return res;
    }
    else
      throw new Exception('error ocurred');
  }
}