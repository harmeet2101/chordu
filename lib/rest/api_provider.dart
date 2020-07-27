import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chordu_exception.dart';
class ApiProvider{


  Future<dynamic> getResponse(String url) async{
    var dynamicResponse;


    try {

      var resp = await http.get(url);
      dynamicResponse = parseResponse(resp);
    } on SocketException catch (e) {
      throw ChorduException('Network Exception',e.toString());
    }

    return dynamicResponse;
  }

  dynamic parseResponse(http.Response response){

    switch(response.statusCode){

      case 200:
        return json.decode(response.body);
      case 400:
          throw BadRequestException(response.body);
      case 401:
        break;
      case 403:
        throw UnauthorizedException(response.body);
      case 404:
        throw ResourceNotFoundException(response.body);
      case 500:
        throw ServerException(response.body.toString());
      default:{

        throw ChorduException('statusCode: ${response.statusCode}',response.body.toString());
      }
    }

  }
}