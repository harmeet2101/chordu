class ThumbnailInfo{


  final String url;
  final int width;
  final int height;

  ThumbnailInfo({this.url,this.width,this.height});

  factory ThumbnailInfo.formJson(Map<String,dynamic> json){

    return ThumbnailInfo(
      url: json['url'],
      width:  json['width'],
      height: json['height']
    );
  }
}