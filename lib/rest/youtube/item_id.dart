class ItemId{
  final String kind;
  final String videoId;

  ItemId({this.kind,this.videoId});

  factory ItemId.fromJson(Map<String,dynamic> json){

    return ItemId(

      kind: json['kind'],
      videoId: json['videoId']
    );
  }
}