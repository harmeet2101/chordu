
import 'package:chordu/rest/youtube/thumbnail.dart';

class Snippet{

  final String channelId;
  final String title;
  final String description;
  final Thumbnail thumbnails;

  Snippet({this.channelId,this.title,this.description,this.thumbnails});


  factory Snippet.fromJson(Map<String,dynamic> json){

    return Snippet(

      channelId: json['channelId'],
      title: json['title'],
      description: json['description'],
      thumbnails: Thumbnail.fromJson(json['thumbnails'])
    );
  }

  @override
  String toString() {
    return 'Snippet{channelId: $channelId, title: $title, description: $description, thumbnails: $thumbnails}';
  }


}