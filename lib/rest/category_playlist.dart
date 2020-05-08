import 'package:chordu/rest/track.dart';

class CategoryPlayList{


  final String type;
  final String name;
  final int count;
  final List<Track> trackList;

  CategoryPlayList({this.type,this.name,this.count,this.trackList});


  factory CategoryPlayList.fromJson(Map<String,dynamic> json){

    return CategoryPlayList(
        type: json['type'],
        name: json['name'],
        count: json['trackcount'],
        trackList:(json['tracklist'] as List).map((i)=>Track.fromJson(i)).toList()
    );
  }
}