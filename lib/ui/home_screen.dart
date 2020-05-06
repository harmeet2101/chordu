import 'dart:convert';

import 'package:chordu/rest/playlist.dart';
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

  @override
  void initState() {
    super.initState();
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
              body: getCustomScrollView()
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

  Widget appBar(){

    return Container(

      color: Color(0xff058377),
      width: double.infinity,
      height: 60,
      child: Row(

        children: <Widget>[

          InkWell(

            onTap: (){
    if (_scaffoldKey.currentState.isDrawerOpen == false) {
    _scaffoldKey.currentState.openDrawer();
    } else {
    _scaffoldKey.currentState.openEndDrawer();
    }

            },
            child: Container(
              width: 55,
              child: Icon(Icons.dehaze,size: 40,),
            ),
          )
        ],
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


  Widget ListHeader(){

    return Container(

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Icon(Icons.track_changes,color: Colors.white,),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            child: Text('Weekly Trending Tracks',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'Play'),),
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

  Widget list01(){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 300,horizontal: 10),
      child: Column(

        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(

              children: <Widget>[

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 17)
                    ,child: Container(width: double.infinity,height:400,child: getContainerList(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ListHeader(),
                ),
                Positioned(
                  bottom: 6,
                  right: 10,
                  child: Container(
                    width: 100,
                    height: 24,
                    child: Center(
                      child: GestureDetector(
                        child: Text('view more..'),
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
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(

              children: <Widget>[

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 17)
                    ,child: Container(width: double.infinity,height:400,child: getContainerList(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ListHeader(),
                ),
                Positioned(
                  bottom: 6,
                  right: 10,
                  child: Container(
                    width: 100,
                    height: 24,
                    child: Center(
                      child: GestureDetector(
                        child: Text('view more..'),
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
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(

              children: <Widget>[

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 17)
                    ,child: Container(width: double.infinity,height:400,child: getContainerList(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ListHeader(),
                ),
                Positioned(
                  bottom: 6,
                  right: 10,
                  child: Container(
                    width: 100,
                    height: 24,
                    child: Center(
                      child: GestureDetector(
                        child: Text('view more..'),
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
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(

              children: <Widget>[

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 17)
                    ,child: Container(width: double.infinity,height:400,child: getContainerList(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ListHeader(),
                ),
                Positioned(
                  bottom: 6,
                  right: 10,
                  child: Container(
                    width: 100,
                    height: 24,
                    child: Center(
                      child: GestureDetector(
                        child: Text('view more..'),
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
          )
        ],
      ),
    );
  }

  Widget getContainerList(){

    final List<String> entries = <String>['A', 'B', 'C','D','E','F','G','H','I','J','K'];
    return ListView.separated(

        separatorBuilder: (BuildContext context ,int index)=>Divider(color: Colors.black26, thickness: 0.5,),
        physics: NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(

            color: Colors.white,
            child: getContainerListItems());
        },
    );
  }


  Widget getContainerListItems(){


    return Row(

      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Container(

                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),image:
                DecorationImage(image: AssetImage('assets/images/bg_home_screen_guitar.jpg'),fit: BoxFit.fill)
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
                    child: Text('Future - Life Is Good (Official Music Video) ft. Drake',style: TextStyle(color: Colors.black,fontSize: 16),
                          maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: true,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('NGm D G# G A# Cm",',style: TextStyle(color: Color(0xff058377),fontSize: 18),maxLines: 1,),
                  ),

                    ],
                  ),

              ),
          ),
        ),
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



  getCustomScrollView() {

    return CustomScrollView(

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
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: double.infinity,
                          child: Center(
                            child: Container(

                              width: 250,
                              height: 50,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                                      child: TextFormField(
                                          maxLines: 1,
                                          showCursor: false,
                                          style: TextStyle(color: Colors.white,fontSize: 20,),

                                          decoration: InputDecoration(

                                            hintText: 'Search Music',
                                            hintStyle: TextStyle(color: Colors.white,fontSize: 20),
                                            border: InputBorder.none,

                                          )

                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 0.5,height: 50,
                                    color: Colors.white,
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10)
                                    ,child:             InkWell(

                                      onTap: (){

                                      },
                                      child: Container(

                                        child: Icon(Icons.search,size: 30,),
                                      ),
                                    ), )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(12.0))
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(

                              image: DecorationImage(image: AssetImage('assets/images/bg_home_screen_guitar.jpg'),fit: BoxFit.fill)

                          ),
                        ),
                        list01()
                      ],
                    ),
                  ),
                )
            ,childCount: 1

        ))

      ],

    );
  }
}



