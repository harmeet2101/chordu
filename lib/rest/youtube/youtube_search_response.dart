


import 'package:chordu/rest/youtube/item.dart';
import 'package:chordu/rest/youtube/page_info.dart';


class YoutubeSearchResponse {

  final String kind;
  final String eTag;
  final String nextPageToken;
  final PageInfo pageInfo;
  final List<Item> items;

  YoutubeSearchResponse(
      {this.kind, this.eTag, this.nextPageToken, this.pageInfo, this.items});

  factory YoutubeSearchResponse.fromJson(Map<String, dynamic> json){
    return YoutubeSearchResponse(

        kind: json['kind'],
        eTag: json['etag'],
        nextPageToken: json['nextPageToken'],
        pageInfo: PageInfo.fromJson(json['pageInfo']),
        items: (json['items'] as List).map((i) => Item.fromJson(i)).toList()
    );
  }

  @override
  String toString() {
    return 'YoutubeSearchResponse{kind: $kind, eTag: $eTag, nextPageToken: $nextPageToken, pageInfo: $pageInfo, items: $items}';
  }

}

