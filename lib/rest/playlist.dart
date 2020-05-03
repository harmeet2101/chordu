import 'dart:convert';

import 'package:chordu/rest/play.dart';

class PlayList{

    final List<Play> plays;

    PlayList({this.plays});

    factory PlayList.fromJson(List<dynamic> json){

      return PlayList(
        plays:json.map((e) =>Play.fromJson(e as Map<String,dynamic>)).toList()
      );
    }

}