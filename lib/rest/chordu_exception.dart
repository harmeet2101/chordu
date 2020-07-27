class ChorduException implements Exception{

  String message;
  String prefix;

  ChorduException([this.prefix,this.message]);

  @override
  String toString() {
    // TODO: implement toString
    return '$prefix: $message';
  }
}

class ResourceNotFoundException extends ChorduException{

  ResourceNotFoundException([String message]):super(message,'Resource not found');
}

class UnauthorizedException extends ChorduException{

  UnauthorizedException([String message]):super(message,'Unauthorized');
}

class BadRequestException extends ChorduException{

  BadRequestException([String message]):super(message,'Bad Request');
}

class FetchDataException extends ChorduException{

  FetchDataException([String message]):super(message,'Exception during fetching response');
}

class ServerException extends ChorduException{

  ServerException([String message]):super(message,'Internal Server Exception');
}