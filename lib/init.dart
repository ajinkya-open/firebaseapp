

import 'package:logging/logging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class Init {
  static final Init _instance = Init._internal();
  bool connectionState=false;
  factory Init() {
  return _instance;
  }
  Init._internal() {
  // initialization logic
  }

  var logger = Logger("app");

  void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  }

  void initConnectivity(){
  
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    logger.info("[connectivity] ${result}");
    if(result == ConnectivityResult.none){  
      connectionState = true;
    }
    else{
      connectionState = false;
    }
    // Got a new connectivity status!
  });

  }


  bool getConnectionState(){  
    return connectionState;
  }

  Logger getLogger() {
  return logger;
  }
}