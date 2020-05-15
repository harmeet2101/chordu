

import 'package:chordu/rest/youtube/item_id.dart';
import 'package:chordu/rest/youtube/snippet.dart';

class Item{

  final String kind;
  final String etag;
  final ItemId itemId;
  final Snippet snippet;

  Item({this.kind,this.etag,this.itemId,this.snippet});

  factory Item.fromJson(Map<String , dynamic> json){

    return Item(

      kind: json['kind'],
      etag: json['etag'],
      itemId: ItemId.fromJson(json['id']),
      snippet: Snippet.fromJson(json['snippet']),
    );
  }

  @override
  String toString() {
    return 'Item{kind: $kind, etag: $etag, itemId: $itemId, snippet: $snippet}';
  }


}