
class Track{

  final String id;
  final String img;
  final String t;
  final String duration;
  final List<String> chords;


  Track({this.id,this.img,this.t,this.duration,this.chords});


  factory Track.fromJson(Map<String,dynamic>json){

    return Track(

        id: json['_id'],
        img: json['img'],
        t: json['t'],
        duration: json['dur'],
        chords: json['chords']!=null?new List<String>.from(json['chords']):new List()
    );
  }

}