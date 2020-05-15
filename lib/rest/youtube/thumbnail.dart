
import 'package:chordu/rest/youtube/thumbnail_info.dart';

class Thumbnail{

  final ThumbnailInfo default_;
  final ThumbnailInfo medium;
  final ThumbnailInfo high;

  Thumbnail({this.default_,this.medium,this.high});

  factory Thumbnail.fromJson(Map<String,dynamic> json){

    return Thumbnail(

      default_: ThumbnailInfo.formJson(json['default']),
      medium: ThumbnailInfo.formJson(json['medium']),
      high: ThumbnailInfo.formJson(json['high']),
    );
  }

}