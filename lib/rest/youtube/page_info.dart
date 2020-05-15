class PageInfo{

  final int totalResults;
  final int resultsPerPage;

  PageInfo({this.totalResults,this.resultsPerPage});


  factory PageInfo.fromJson(Map<String,dynamic> json){

    return PageInfo(

      totalResults:  json['totalResults'],
      resultsPerPage:  json['resultsPerPage'],
    );
  }
}