import 'dart:convert';
import 'package:chordu/rest/play.dart';
import 'package:chordu/rest/playlist.dart';
import 'package:chordu/rest/track.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }

}
class HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final List<String> items = ['Home','Recently Viewed','Login','Weekly Top','Pop Hotlist'];
  final List<IconData> iconsList = [Icons.home,Icons.history,Icons.person,Icons.music_note,Icons.queue_music];
  Future<PlayList> playList;
  ScrollController _scrollController;
  List<Play> plays;
  @override
  void initState() {
    super.initState();
    //_scrollController = new ScrollController();
    //_scrollController.addListener(scrollListener);
    playList = getData();


  }

  Widget build(BuildContext buildContext){

    return FutureBuilder(
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
              child: Center(child: new CircularProgressIndicator(valueColor:
              new AlwaysStoppedAnimation<Color>(Colors.greenAccent),))
          );
      },
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



  Widget getContainerListItems(String imgUrl,String title,String chords){


    return Row(

      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: ClipRRect(

              borderRadius: BorderRadius.circular(6.0),
              child: Container(

                height: 80,
                child: FadeInImage.assetNetwork(placeholder:'assets/images/bg_home_screen_guitar.jpg'
                  , image: imgUrl,fit: BoxFit.fill,),

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
    );
  }

  Widget getCustomScrollView(PlayList playList) {

    return CustomScrollView(

      controller: _scrollController,
      slivers: <Widget>[

        SliverAppBar(
          title: Text(AppConstants.APP_NAME),
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
        ,SliverList(delegate: SliverChildBuilderDelegate(

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
                    Padding(padding: EdgeInsets.symmetric(vertical: 30),child:
                    Text(AppConstants.HOME_PAGE_DESC_TEXT_0,softWrap: true,style:
                    TextStyle(fontSize: 28,color: Colors.white,fontFamily: 'Play'),textAlign: TextAlign.center,),),
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
                                    showCursor: false,
                                    style: TextStyle(color: Colors.white,fontSize: 18,),

                                    decoration: InputDecoration(

                                      hintText: AppConstants.HOME_PAGE_SEARCH_BAR_TEXT,
                                      hintStyle: TextStyle(color: Colors.grey[600],fontSize: 16),
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

                                },
                                child: Container(

                                  child: Icon(Icons.search,size: 35,color: Colors.grey[600],),
                                ),
                              ), )
                          ],
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[200],
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

        ))

      ],

    );
  }






  Future<PlayList> getData() async{


    final resp = await http.get('https://chordu.com/flutter_service_home.php');

    if(resp.statusCode==200){

      return PlayList.fromJson(json.decode(resp.body));
    }
    else
      throw new Exception('error ocurred');
  }

   List<Widget> getMainContent(PlayList playList){

    List<Widget> wl = new List();

    for(int i =0;i<playList.plays.length;i++){

      wl.add(getContainer(playList.plays[i].name,playList.plays[i].trackList, 5));
    }
    wl.add(bottomPageDescription());
    return wl;
  }

  Widget getContainer(String title,List<Track> trackList,int size){

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

  List<Widget> containerItems(List<Track> trackList,int size){

    List<Widget> wl = new List();

    for(int i =0;i<size;i++){
      wl.add(Container(
          height: 110,
          color: Colors.white,
          child: getContainerListItems(trackList[i].img,trackList[i].t,trackList[i].chords.join(" "))));
    }

    return wl;
  }

    scrollListener() {

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
}



