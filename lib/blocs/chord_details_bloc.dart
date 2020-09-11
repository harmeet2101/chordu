import 'dart:async';
import 'dart:collection';

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/repository/chord_details_repo.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/chord_details.dart';
import 'package:chordu/rest/chord_info.dart';

class ChordDetailsBloc extends Bloc{

  StreamController<Response<ChordDetails>> _streamController;
  ChordDetailsRepo _chordDetailsRepo;

  var chordsKeyList = new List<int>();
  var chordsValueList = new List<String>();
  List<ChordInfo> chordsInfoList = new List();

  Stream<Response<ChordDetails>> get chordDetailsStream =>_streamController.stream;
  StreamSink<Response<ChordDetails>> get chordDetailsSink=>_streamController.sink;




  ChordDetailsBloc(){
    _streamController = new StreamController<Response<ChordDetails>>();
    _chordDetailsRepo = new ChordDetailsRepo();
   // fetchChordDetails(chordID);

  }

  void fetchChordDetails(String id)async{

    print('Fetching chord details....');
    chordDetailsSink.add(Response.loading('Fetching chord details....'));
    try{
      ChordDetails  resp = await _chordDetailsRepo.getChordDetails(id);
      calc(resp);
      chordDetailsSink.add(Response.completed(resp));
    }catch(e){
      chordDetailsSink.add(Response.error(e.toString()));
    }
  }

  void calc(ChordDetails res){

    String chordDataPage = res.chordDataPage;
    String parsedChords =chordDataPage.substring(1,chordDataPage.length-1);

    List<String> ls = parsedChords.split(",");
    Map map = new LinkedHashMap<String,String>();
    var size = 0;

    for(int i =1;i<=ls.length;i++){
      var temp = ls[i-1].split(":");
      var key = temp[0].substring(1,temp[0].length-1);

      chordsKeyList.add(int.parse(key));
      var value = temp[1].substring(1,temp[1].length-1);
//      print('${}ls[i]');
      chordsValueList.add(value);
      map.putIfAbsent(key, () => value);
      size = int.parse(key);
    }



      for(int i=1;i<=(size+16);i++){


        if(map.containsKey("$i")){
          chordsInfoList.add(new ChordInfo(location: i,text:map["$i"],isActive: true ));
        }else{
          chordsInfoList.add(new ChordInfo(location: i,text:'',isActive: false ));
        }
      }


  }


  @override
  void dispose() {
    _streamController?.close();
  }
}