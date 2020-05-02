import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final List<String> items = ['Home','Recently Viewed','Login','Weekly Top','Pop Hotlist'];
  final List<IconData> iconsList = [Icons.home,Icons.history,Icons.person,Icons.music_note,Icons.queue_music];

  Widget build(BuildContext buildContext){

    return Scaffold(

      appBar: AppBar(

        title: Text(AppConstants.APP_NAME),
        leading: IconButton(icon: Icon(Icons.dehaze), onPressed:(){
          if (_scaffoldKey.currentState.isDrawerOpen == false) {
            _scaffoldKey.currentState.openDrawer();
          } else {
            _scaffoldKey.currentState.openEndDrawer();
          }
        })

      ),
      body: Scaffold(
        key: _scaffoldKey,
        drawer: Theme(

          data: Theme.of(buildContext).copyWith(
            canvasColor: Colors.black54
          ),
          child: Drawer(

            child: ListView.separated(itemBuilder: (buildContext,int index)=>getListViewItems(index),
                separatorBuilder: (buildContext ,int index)=>Divider(
                  color: Colors.white,
                  height: 0.5,
                ),
                itemCount: 5),
          ),
        ),
      ),
    );



  }

  Widget getListViewItems(int index){


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
        print("Index: $index");

      },
    );
  }
  

}