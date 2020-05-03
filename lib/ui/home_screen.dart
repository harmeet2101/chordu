import 'dart:convert';

import 'package:chordu/rest/playlist.dart';
import 'package:chordu/rest/playlist.dart';
import 'package:chordu/rest/playlist.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/material.dart';
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
      builder: (buildContext,snapshot){

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
              body: CustomScrollView(

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

                          (buildContext,index) =>ListTile(title: Text('index: $index'),)
                      ,childCount: 100

                  ))

                ],

              )
          );
        }else
          return Center(child: new CircularProgressIndicator());
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

  Future<PlayList> getData() async{


    final resp = await http.get('https://chordu.com/flutter_service_home.php');

    if(resp.statusCode==200){

      return PlayList.fromJson(json.decode(resp.body));
    }
    else
      throw new Exception('error ocurred');
  }
}



