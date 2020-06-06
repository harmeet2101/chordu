class CommonUtils{


  static String convertTime(int timeInMilliseconds) {
    Duration timeDuration = Duration(milliseconds: timeInMilliseconds);

    int seconds = timeDuration.inSeconds % 60;
    int minutes = timeDuration.inMinutes % 60;
    int hours = timeDuration.inHours % 60;

    /*if (hours > 0){
      return '${hours}:${minutes}:${seconds}';
    }else if(minutes > 0){
      return '${minutes}:${seconds}';
    }else {
      return '${seconds}';
    }*/


    return '${minutes>10?minutes:0}:${seconds}';

  }
}