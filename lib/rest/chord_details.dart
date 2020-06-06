class ChordDetails{

  final String tid;
  final String tname;
  final String pageUrl;
  final String chordDataPage;
  final String chordVariationComputed;
  final int bpm;
  final bool key;
  final String isFavorite;
  final int asset_ver;


  ChordDetails({this.tid,this.tname,this.pageUrl,this.chordDataPage,
    this.chordVariationComputed,this.bpm,this.key,this.isFavorite,this.asset_ver});

  factory ChordDetails.fromJson(Map<String,dynamic> json){

    return ChordDetails(
      tid: json['tid'],
      tname: json['tname'],
      pageUrl: json['pageUrl'],
      chordDataPage: json['chordDataPage'],
      chordVariationComputed: json['chordVariationComputed'],
      bpm: json['bpm'],
      key: json['key'],
      isFavorite: json['isFavorite'],
      asset_ver: json['asset_ver'],

    );
  }

  @override
  String toString() {
    return 'ChordDetails{tid: $tid, tname: $tname, pageUrl: $pageUrl,'
        ' chordDataPage: $chordDataPage, chordVariationComputed: $chordVariationComputed, '
        'bpm: $bpm, key: $key, isFavorite: $isFavorite, asset_ver: $asset_ver}';
  }


}