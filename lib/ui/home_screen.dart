import 'dart:convert';
import 'package:chordu/rest/category_playlist.dart';
import 'package:chordu/rest/play.dart';
import 'package:chordu/rest/playlist.dart';
import 'package:chordu/rest/track.dart';
import 'package:chordu/rest/youtube/item.dart';
import 'package:chordu/rest/youtube/youtube_search_response.dart';
//import 'package:chordu/ui/custom_player_screen.dart';
import 'package:chordu/ui/player_screen.dart';
import 'package:chordu/ui/progressbars/spin_fade_circle_view.dart';
import 'package:chordu/ui/youtube/yt_main_screen.dart';
import 'package:chordu/ui/youtube/yt_player_screen.dart';
import 'package:chordu/ui/youtube/yt_player_screen_1.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'chord_app_details.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final List<String> items = ['Home','Recently Viewed','Login','Weekly Top','Pop Hotlist'];
  final List<IconData> iconsList = [Icons.home,Icons.history,Icons.person,Icons.music_note,Icons.queue_music];
  Future<PlayList> playList;
  Future<CategoryPlayList> categoryPlayList;
  ScrollController _scrollController;
  TextEditingController _searchController = new TextEditingController();
  List<Play> plays;
  bool showCompleteList = false;
  bool showSearchList = false;
  int selectionIndex = -1;
  //InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(scrollListener);
    playList = getData();

    //FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-8165933075459073~7203682616');
   // _interstitialAd = createInterstitialAd()..load();
  }




  Widget build(BuildContext buildContext){

    return WillPopScope(

      onWillPop: ()async{

        if(showCompleteList) {
          setState(() {
            showCompleteList = false;
          });
          return false;
        }
        if(showSearchList){

            setState(() {
              showSearchList = false;
            });
          return false;
        }else
          return true;

      },
      child: FutureBuilder(
        future: playList,
        builder: (buildContext,AsyncSnapshot<PlayList> snapshot){

          if(snapshot.connectionState==ConnectionState.none &&
            snapshot.hasData ==null
          ){
             return new Container();
          }else if(snapshot.hasData){
            return Scaffold(

                key: _scaffoldKey,
                drawer: Theme(

                  data: Theme.of(buildContext).copyWith(
                      canvasColor: Colors.black54
                  ),
                  child: Drawer(

                    child: ListView.separated(itemBuilder: (buildContext,int index)=>getListViewItems(buildContext,index),
                        separatorBuilder: (buildContext ,int index)=>Divider(
                          color: Colors.white,
                          height: 0.5,
                        ),
                        itemCount: 5),
                  ),
                ) ,
                body: getCustomScrollView(snapshot.data)
            );
          }else
            return Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Center(child: SpinFadingCircle(color: Color(0xff058377)))
            );
        },
      ),
    );

  }

  Widget getListViewItems(BuildContext buildContext,int index){


    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Row(

          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              child: Icon(iconsList[index],color: Colors.white,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              child: Text(items[index],style: TextStyle(color: Colors.white,fontSize: 18.0),),
            )
          ],
        ),
      ),

      onTap: (){
        Navigator.pop(buildContext);
      },
    );
  }

  Widget list(PlayList playList){

    return Padding(
      padding: EdgeInsets.fromLTRB(0,250,0,0),
      child: Column(
        children: getMainContent(playList),
      ),
    );
  }

  Widget getContainerListItems(String duration,String imgUrl,String title,String chords,String id){


    return Material(
      child: InkWell(
        child: Row(

            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(6.0),
                    child: Stack(
                      children: <Widget>[

                        Container(
                          width: double.infinity,
                          height: 80,
                          child: FadeInImage.assetNetwork(placeholder:'assets/images/default_place_holder.png'
                            , image: imgUrl,fit: BoxFit.fill,),

                        )
                        ,Positioned(child: Container(

                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0)
                        ),

                          child: Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            child: Text(duration,style: TextStyle(color: Colors.white,fontSize: 15),),
                          )),
                        ),left: 5,bottom: 5,)
                      ] ,
                    ),
                  ),

                ),

              ),
              Expanded(
                flex: 1,
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 10, 20),
                  child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Text(title,style: TextStyle(color: Colors.black,fontSize: 16),
                                maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(chords,style: TextStyle(color: Color(0xff058377),
                              fontSize: 18),maxLines: 1,overflow: TextOverflow.clip,softWrap: true,),
                        ),

                          ],
                        ),

                    ),
                ),
              ),
            ],
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                /*PlayerScreen(videoId:id
                  ,thumbnailUrl: imgUrl,title: title,)*/
            YTPlayerScreen1(videoId: id,thumbnailUrl: imgUrl,
              title: title,)
                ));
          }
      ),

    );
  }

  Widget getCustomScrollView(PlayList playList) {

    return CustomScrollView(

      controller: null,
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
       //   title: Text(AppConstants.APP_NAME),
          leading: IconButton(icon: Icon(Icons.dehaze), onPressed:(){

            if (_scaffoldKey.currentState.isDrawerOpen == false) {
              _scaffoldKey.currentState.openDrawer();
            } else {
              _scaffoldKey.currentState.openEndDrawer();
            }
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
        )
        ,abstractListOfSongs(playList),
        completeListOfSongs(playList),
        searchListOfSongs(_searchController.text.trim())
      ],

    );
  }

  Future<PlayList> getData() async{


    final resp = await http.get('https://chordu.com/flutter_service_home.php');

    if(resp.statusCode==200){

     // print(json.decode(resp.body));
      return PlayList.fromJson(json.decode(resp.body));
    }
    else
      throw new Exception('error ocurred');
  }



  List<Widget> getMainContent(PlayList playList){

    List<Widget> wl = new List();

    for(int i =0;i<playList.plays.length;i++){

      wl.add(getContainer(i,playList.plays[i].name,playList.plays[i].trackList, 3));
    }
    wl.add(ChorduAppDetails());
    return wl;
  }

  Widget getContainer(int index, String title,List<Track> trackList,int size){

    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,10),
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(

          children: <Widget>[

            Align(
              alignment: Alignment.topLeft,
              child: Padding(padding: EdgeInsets.symmetric(vertical: 17)
                ,child: Container(width: double.infinity,child:
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Column(

                    children: containerItems(trackList,size),

                  ),
                ) ,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: containerHeader(title),
            ),
            Positioned(
              bottom: 6,
              right: 10,
              child: Container(
                width: 120,
                height: 30,
                child: Center(
                  child: GestureDetector(
                    child: Text('view more..',style: TextStyle(fontFamily: 'Play',fontSize: 16),),
                    onTap: (){

                      setState(() {
                        selectionIndex = index;
                        showCompleteList = true;
                      });
                    },
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget containerHeader(String title){

    return Container(

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Icon(Icons.check_circle,color: Colors.white,),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            child: Text(title,style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'Play'),),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color(0xff058377),
          shape: BoxShape.rectangle,
          boxShadow: [BoxShadow(
            color: Colors.grey,
            blurRadius: 14.0, // soften the shadow
            spreadRadius: 2.0, //extend the shadow

          )],
          border: Border.all(
            color: Colors.white,
            width: 1.0,

          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),

    );
  }


  List<Widget> containerItems(List<Track> trackList,int size){

    List<Widget> wl = new List();

    for(int i =0;i<size;i++){
      wl.add(Container(
          height: 110,
          color: Colors.white,
          child: getContainerListItems(trackList[i].duration,trackList[i].img,
              trackList[i].t,trackList[i].chords.join(" "),trackList[i].id)));
    }

    return wl;
  }

  Widget completeListOfSongs(PlayList playList){
    return showCompleteList?CategoryBuilder(playList.plays[selectionIndex].name)/*SliverList(delegate:new SliverChildListDelegate(_buildList(selectionIndex,playList)),)*/:
    SliverList(delegate: new SliverChildListDelegate(new List(0)));
  }

  Widget searchListOfSongs(String searchString){
    return showSearchList?SearchBuilder(search: searchString):
    SliverList(delegate: new SliverChildListDelegate(new List(0)));
  }



  Widget abstractListOfSongs(PlayList playList){
    return (!showCompleteList && !showSearchList)?SliverList(delegate: SliverChildBuilderDelegate(


    (buildContext,index) =>SingleChildScrollView(

      child: Container(
        color: Colors.grey[200],
        child: Stack(

          children: <Widget>[


            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: Center(
                child: null,
              ),
              decoration: BoxDecoration(

                  image: DecorationImage(image: AssetImage('assets/images/bg_home_screen_guitar.jpg'),fit: BoxFit.fill)

              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 30,horizontal: 25),child:
            Text(AppConstants.HOME_PAGE_DESC_TEXT_0,softWrap: true,style:
            TextStyle(fontSize: 28,color: Colors.white,fontFamily: 'Play',),textAlign: TextAlign.center,),),
            Align(
              alignment: Alignment.center,
              child: Padding(padding: EdgeInsets.symmetric(vertical: 160),child:
              Container(

                width: 300,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                        child: TextFormField(
                            maxLines: 1,
                            showCursor: true,
                            style: TextStyle(color: Colors.black,fontSize: 18,),
                            controller: _searchController,
                            decoration: InputDecoration(

                              hintText: AppConstants.HOME_PAGE_SEARCH_BAR_TEXT,
                              hintStyle: TextStyle(color: Color(0xff989898),fontSize: 16),
                              border: InputBorder.none,

                            )

                        ),
                      ),
                    ),
                    Container(
                      width: 0.5,height: 60,
                      color: Colors.grey[600],
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10)
                      ,child:             InkWell(

                        onTap: (){
                          showSearchPage();
                        },
                        child: Container(

                          child: Icon(Icons.search,size: 35,color: Color(0xff8D9AA5),),
                        ),
                      ), )
                  ],
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xffEAEAEA),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
              ),),
            ),
            list(playList)


          ],
        ),
      ),
    )
    ,childCount: 1

    )):SliverList(delegate:
    new SliverChildListDelegate(new List(0)));
  }

  scrollListener() {

    print('controller');
    if(_scrollController.offset>=_scrollController.position.maxScrollExtent
        &&!_scrollController.position.outOfRange){
        setState(() {
          print("Bottom");
        });
    }if(
    _scrollController.offset <= _scrollController.position.maxScrollExtent
        &&!_scrollController.position.outOfRange
    ){
      setState(() {
        print("top");
      });
    }
  }

  void showSearchPage() {

    if(_searchController.text.trim().isEmpty){
      return;
    }
    setState(() {

      showSearchList = true;
      showCompleteList = false;
    });

  }

  /*MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-8165933075459073/1951355930',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }*/


}

class CategoryBuilder extends StatefulWidget{

  String category;

  CategoryBuilder(this.category);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryBuilderState();
  }
}

class CategoryBuilderState extends State<CategoryBuilder>{

  Future<CategoryPlayList> categoryPlayList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryPlayList = getCategoryData(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(builder: (context,AsyncSnapshot<CategoryPlayList> snapshot){

      if(snapshot.connectionState==ConnectionState.none &&
          snapshot.hasData ==null
      ){
        return SliverList(delegate: new SliverChildListDelegate(new List(0)));
      }else if(snapshot.hasData){
        List<Widget> wl = new List();

        wl.add(getHeading());
        for(int i =0;i<snapshot.data.trackList.length;i++){

          wl.add(getContainerListItems(snapshot.data.trackList[i].duration,
              snapshot.data.trackList[i].img,snapshot.data.trackList[i].t,
              snapshot.data.trackList[i].chords.join(" "),snapshot.data.trackList[i].id));
        }
        wl.add(bottomPageDescription());
        return SliverList(delegate:new SliverChildListDelegate(wl),);
      }
      else{
        return SliverList(delegate: new SliverChildListDelegate(new List(0)));
      }
    },future: categoryPlayList,);
  }

  Widget getContainerListItems(String duration,String imgUrl,String title,String chords,String id){


    return Material(
      child: InkWell(
        child: Row(

          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: ClipRRect(

                  borderRadius: BorderRadius.circular(6.0),
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: double.infinity,
                        height: 80,
                        child: FadeInImage.assetNetwork(placeholder:'assets/images/default_place_holder.png'
                          , image: imgUrl,fit: BoxFit.fill,),

                      )
                      ,Positioned(child: Container(

                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0)
                        ),

                        child: Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: Text(duration,style: TextStyle(color: Colors.white,fontSize: 15),),
                        )),
                      ),left: 5,bottom: 5,)
                    ] ,
                  ),
                ),

              ),

            ),
            Expanded(
              flex: 3,
              child:Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 10, 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18),
                          maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(chords,style: TextStyle(color: Color(0xff058377),
                            fontSize: 18),maxLines: 1,overflow: TextOverflow.clip,softWrap: true,),
                      ),

                    ],
                  ),

                ),
              ),
            ),
          ],
        ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
              PlayerScreen(videoId:id
                ,thumbnailUrl: imgUrl,title: title,),
          ));

        },
      ),
    );
  }

  Widget getHeading(){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(

        children: <Widget>[

          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Icon(Icons.check_circle,
            color: Color(0xff058377),size: 40,),),
          Text(widget.category,style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'Play'),)
        ],
      ),
    );
  }
  Widget bottomPageDescription(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20,0,0),
      child: Container(

        color: Colors.black54,
        width: MediaQuery.of(context).size.width,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(AppConstants.HOME_PAGE_DESC_TEXT_1,style: TextStyle(color: Colors.greenAccent,fontSize: 16),),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text(AppConstants.HOME_PAGE_DESC_TEXT_2,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
                  Text(AppConstants.HOME_PAGE_DESC_TEXT_3,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),)
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0),child:
            Text(AppConstants.HOME_PAGE_DESC_TEXT_4,style: TextStyle(color: Colors.orangeAccent,fontSize: 14),),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child:
            Text(AppConstants.HOME_PAGE_DESC_TEXT_5,textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54,fontSize: 14,height: 1.5),)
              ,)

          ],
        ),
      ),
    );
  }

  Future<CategoryPlayList> getCategoryData(String category) async{


    final resp = await http.get('https://chordu.com/flutter_service_playlist.php?listid=$category');

    if(resp.statusCode==200){

      return CategoryPlayList.fromJson(json.decode(resp.body));
    }
    else
      throw new Exception('error ocurred');
  }
}

class SearchBuilder extends StatefulWidget{

  String search;

  SearchBuilder({this.search});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchBuilderState();
  }
}

class SearchBuilderState extends State<SearchBuilder>{

  Future<YoutubeSearchResponse> _searchResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchResponse = fetchSongs(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(builder: (context,AsyncSnapshot<YoutubeSearchResponse> snapshot){

      if(snapshot.connectionState==ConnectionState.none &&
          snapshot.hasData ==null
      ){
        return SliverList(delegate: new SliverChildListDelegate(new List(0)));
      }else if(snapshot.hasData){
        List<Widget> wl = new List();

        wl.add(getHeading());
        for(int i =0;i<snapshot.data.items.length;i++){

          wl.add(getContainerListItems('0.0',
              snapshot.data.items[i].snippet.thumbnails.high.url,
              snapshot.data.items[i].snippet.title,'Request Chords',snapshot.data.items[i]));
        }
        wl.add(bottomPageDescription());

        return SliverList(delegate:new SliverChildListDelegate(wl),);
      }
      else{
        return SliverList(delegate: new SliverChildListDelegate(new List(0)));
      }
    },future: _searchResponse,);
  }

  Widget getContainerListItems(String duration,String imgUrl,String title,String chords,Item item){


    return Material(
      child: InkWell(
        child: Row(

          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: ClipRRect(

                  borderRadius: BorderRadius.circular(6.0),
                  child: Stack(
                    children: <Widget>[

                      Container(
                        width: double.infinity,
                        height: 80,
                        child: FadeInImage.assetNetwork(placeholder:'assets/images/default_place_holder.png'
                          , image: imgUrl,fit: BoxFit.fill,),

                      )
                      ,Positioned(child: Container(

                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0)
                        ),

                        child: Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: Text(duration,style: TextStyle(color: Colors.white,fontSize: 15),),
                        )),
                      ),left: 5,bottom: 5,)
                    ] ,
                  ),
                ),

              ),

            ),
            Expanded(
              flex: 3,
              child:Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 10, 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18),
                          maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(chords,style: TextStyle(color: Color(0xff058377),
                            fontSize: 18),maxLines: 1,overflow: TextOverflow.clip,softWrap: true,),
                      ),

                    ],
                  ),

                ),
              ),
            ),
          ],
        ),
        onTap: (){

          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
              PlayerScreen(videoId:item.itemId.videoId
                ,thumbnailUrl: item.snippet.thumbnails.default_.url,title: title,),
          ));

        },
      ),
    );
  }

  Widget getHeading(){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(

        children: <Widget>[

          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Icon(Icons.search,
            color: Color(0xff058377),size: 40,),),
          Text('Search Results: ${widget.search}',style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'Play',),maxLines: 2,softWrap: true,)
        ],
      ),
    );
  }
  Widget bottomPageDescription(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20,0,0),
      child: Container(

        color: Colors.black54,
        width: MediaQuery.of(context).size.width,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(AppConstants.HOME_PAGE_DESC_TEXT_1,style: TextStyle(color: Colors.greenAccent,fontSize: 16),),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text(AppConstants.HOME_PAGE_DESC_TEXT_2,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
                  Text(AppConstants.HOME_PAGE_DESC_TEXT_3,style: TextStyle(color: Colors.blueAccent,fontSize: 14),),)
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0),child:
            Text(AppConstants.HOME_PAGE_DESC_TEXT_4,style: TextStyle(color: Colors.orangeAccent,fontSize: 14),),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child:
            Text(AppConstants.HOME_PAGE_DESC_TEXT_5,textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54,fontSize: 14,height: 1.5),)
              ,)

          ],
        ),
      ),
    );
  }

  Future<YoutubeSearchResponse> fetchSongs(String searchString)async {

    if(searchString.isEmpty){
      return null;
    }
    var resp = await http.get('https://www.googleapis.com/youtube/v3/search?'
        'part=snippet&maxResults=50&q=$searchString&key=${AppConstants.YOUTUBE_PLAYER_API_KEY}');

    if(resp.statusCode==200){

      YoutubeSearchResponse response = YoutubeSearchResponse.fromJson(json.decode(resp.body));
      print(response);
      return response;
    }
    else
      throw new Exception('error ocurred');

  }
}



