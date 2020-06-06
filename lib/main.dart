import 'dart:async';

import 'package:chordu/ui/home_screen.dart';
import 'package:chordu/utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(ChorduApp());

class ChorduApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.

        /*
        *  Theme colors: #093431, #058377
            Background colors: #252525, white
            Font colors: #777, #fafafa, white
        * */

        primaryColor: Color(0xff058377),
        accentColor: Colors.white,
        fontFamily: 'Play',
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white,fontSize: 22.0),
        )
      ),
      home: SplashScreenPage(title:AppConstants.APP_NAME),
      routes: <String,WidgetBuilder>{

        "/home":(BuildContext)=>HomeScreen()
      },
    );
  }
}

class SplashScreenPage extends StatefulWidget {

  final String title;

  SplashScreenPage({this.title});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   startDelay();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(

        color: Color(0xff093431),
        child: Stack(
        children: <Widget>[
            Center(child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/splash_icon.png',),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(widget.title,style: TextStyle(color: Colors.white,fontSize: 20.0,
                      decoration: TextDecoration.none),),
                ),
              ],
            )),
            Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.greenAccent),))

        ],),
      ),
    );
  }


  startDelay()async{

      var _duration = Duration(milliseconds: AppConstants.SPLASH_DELAY_DURATION);
      new Timer(_duration, navigateToHomePage );
  }

  void navigateToHomePage(){

    Navigator.of(context).pushReplacementNamed("/home");

  }
}
