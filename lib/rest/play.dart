import 'package:chordu/rest/track.dart';

class Play{

  final String type;
  final String name;
  final String playlistId;
  final String link;
  final List<Track> trackList;

  Play({this.type,this.name,this.playlistId,this.link,this.trackList});


  factory Play.fromJson(Map<String,dynamic> json){

    return Play(
        type: json['type'],
        name: json['name'],
        playlistId: json['playlistId'],
        link: json['link'],
        trackList:(json['tracklist'] as List).map((i)=>Track.fromJson(i)).toList()
    );
  }
}