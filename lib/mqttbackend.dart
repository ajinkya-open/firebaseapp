/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'init.dart';
import 'package:logging/logging.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';


import 'screen/controller.dart';

/// An annotated simple subscribe/publish usage example for mqtt_server_client. Please read in with reference
/// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
/// files for separate subscribe/publish tests.

/// First create a client, the client is constructed with a broker name, client identifier
/// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
/// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
/// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
/// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
/// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
/// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
/// of 1883 is used.
/// If you want to use websockets rather than TCP see below.
///
///
///

class MQttService {
  Logger log = Init().getLogger();

  static final MQttService _instance = MQttService._internal();
  factory MQttService() {
    return _instance;
  }
  MQttService._internal() {
    // initialization logic
  }

  var uuid = Uuid();

  var client;
  var pongCount = 0; // Pong counter

  void subScribeTo(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void setBrokerPort(String broker, int port) {
    client = MqttServerClient('$broker', '');
  }

  Future<bool> connect() async {
    /// never send malformed messages.
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      log.info('EXAMPLE::client exception - $e');
      client.disconnect();
      return false;
    } on SocketException catch (e) {
      // Raised by the socket layer
      log.info('EXAMPLE::socket exception - $e');
      client.disconnect();
      return false;
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      log.info('EXAMPLE::Mosquitto client connected');
      return true;
      // notifyBroker();
    } else {
      /// Use status here rather than state if you also want the broker return code.
      log.info(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return false;
      // exit(-1);
    }
  }


  MqttServerClient getClient(){ 
    return client;
  }

  void subscribeToRelevant(String subTopic) {
    client.subscribe(subTopic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.

  }

  void disconnect() {
    client.disconnect();
  }

  void publish(String topic, String msg) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);

    // log.info('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
    // client.subscribe(topic, MqttQos.exactlyOnce);

    /// Publish it
    log.info('EXAMPLE::Publishing our topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void notifyBroker() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('connected');
    client.publishMessage(
        'from_app_notice$clientId', MqttQos.exactlyOnce, builder.payload!);
    log.info("notify to broker");
  }

  String clientId = "";

  Future<void> init() async {
    clientId = uuid.v1();
    // final client = MqttServerClient(MQTT_BROKER, 'fromapp_${uuid.v1()}');
    // client.logging(on: true);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 2000; // milliseconds
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('fromapp_$clientId')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message');
    client.connectionMessage = connMess;

    // await connect();
    // notifyBroker();
    // subscribeToRelevant();

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.

    // client.published!.listen((MqttPublishMessage message) {
    //   log.info(
    //       'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    // });

    /// Lets publish to our topic
    /// Use the payload builder rather than a raw buffer
    /// Our known topic to publish to

    //////////////////// sublish to mqtt
    // const pubTopic = 'Dart/Mqtt_client/testtopic';
    // final builder = MqttClientPayloadBuilder();
    // builder.addString('Hello from mqtt_client');

    // /// Subscribe to it
    // log.info('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
    // client.subscribe(pubTopic, MqttQos.exactlyOnce);

    // /// Publish it
    // log.info('EXAMPLE::Publishing our topic');
    // client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

    /// Ok, we will now sleep a while, in this gap you will see ping request/response
    /// messages being exchanged by the keep alive mechanism.
    // log.info('EXAMPLE::Sleeping....');
    // await MqttUtilities.asyncSleep(60);

    // subsubscribing and ending session
    // log.info('EXAMPLE::Unsubscribing');
    // client.unsubscribe(topic);

    // /// Wait for the unsubscribe message from the broker if you wish.
    // await MqttUtilities.asyncSleep(2);
    // log.info('EXAMPLE::Disconnecting');
    // client.disconnect();
    // log.info('EXAMPLE::Exiting normally');
    // return 0;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    log.info('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    log.info('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      log.info(
          'EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      log.info(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
    if (pongCount == 3) {
      log.info('EXAMPLE:: Pong count is correct');
    } else {
      log.info(
          'EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  /// The successful connect callback
  void onConnected() {
    log.info(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    log.info('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }
}
