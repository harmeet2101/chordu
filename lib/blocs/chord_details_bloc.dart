import 'dart:async';

import 'package:chordu/blocs/bloc.dart';
import 'package:chordu/repository/chord_details_repo.dart';
import 'package:chordu/rest/Response.dart';
import 'package:chordu/rest/chord_details.dart';

class ChordDetailsBloc extends Bloc{

  StreamController<Response<ChordDetails>> _streamController;
  ChordDetailsRepo _chordDetailsRepo;
  Stream<Response<ChordDetails>> get chordDetailsStream =>_streamController.stream;
  StreamSink<Response<ChordDetails>> get chordDetailsSink=>_streamController.sink;

  final String chordID;


  ChordDetailsBloc({this.chordID}){
    _streamController = new StreamController<Response<ChordDetails>>();
    _chordDetailsRepo = new ChordDetailsRepo();
    fetchChordDetails(chordID);

  }

  void fetchChordDetails(String id)async{

    chordDetailsSink.add(Response.loading('Fetching chord details....'));
    try{
      ChordDetails resp = await _chordDetailsRepo.getChordDetails(id);
      chordDetailsSink.add(Response.completed(resp));
    }catch(e){
      chordDetailsSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _streamController?.close();
  }
}