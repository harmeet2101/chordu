class ChordInfo{

  final int location;
  final String text;
  final bool isActive;


  ChordInfo({this.location,this.text,this.isActive});

  @override
  String toString() {
    return 'ChordInfo{location: $location, text: $text, isActive: $isActive}';
  }


}