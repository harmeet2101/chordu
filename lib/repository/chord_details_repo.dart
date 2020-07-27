import 'package:chordu/rest/api_provider.dart';
import 'package:chordu/rest/chord_details.dart';

class ChordDetailsRepo{

  ApiProvider _apiProvider = new ApiProvider();


  Future<ChordDetails> getChordDetails(String id)async{
    var resp = await _apiProvider.getResponse('https://chordu.com/flutter_service_chords.php?tid=${id}');
    ChordDetails chordDetails = ChordDetails.fromJson(resp);
    return chordDetails;
  }
}