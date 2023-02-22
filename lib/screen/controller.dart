import 'package:firebaseapp/mqttbackend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebaseapp/init.dart';
import 'package:logging/logging.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:mqtt_client/mqtt_server_client.dart';

class MasterController extends GetxController {
  TextEditingController brokerC = TextEditingController(text: '127.0.0.1');
  TextEditingController subC = TextEditingController(text: 'text');

  final msg = "".obs;

  final connectionState = false.obs;

  Logger log = Init().getLogger();

  final List<Map<dynamic,dynamic>> msges= <Map<dynamic,dynamic>>[].obs;

  Future<void> setNewBroker() async {
    MQttService().setBrokerPort(brokerC.text, 1883);
    await MQttService().init();
    connectionState.value = await MQttService().connect();
    log.info(
        "broker new ${brokerC.text} status Connected? ${connectionState.value}");
  }

  void subscribe() {
    MQttService().subscribeToRelevant(subC.text);

    startListening();
  }


  void startListening() {
    MqttServerClient client = MQttService().getClient();
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log.info(
          'EXAMPLE:: conroller log Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
          Map<dynamic,dynamic> msg = {  
            'topic':c[0].topic,
            'msg':pt
          };
          log.info(msg);
          msges.insert(0,msg) ;
    });
  }
}
