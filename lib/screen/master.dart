import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

import 'package:firebaseapp/const.dart';

import 'package:firebaseapp/init.dart';
import 'package:logging/logging.dart';

class MasterPage extends GetView<MasterController> {
  @override
  Widget build(BuildContext context) {
    Logger log = Init().getLogger();
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(
              hintText: 'broker',
              labelText: 'broker',
            ),
            controller: controller.brokerC,
          ),
          actions: [
            Obx(() {
              return IconButton(
                onPressed: () {
                  //TODO : add connection logic
                  log.info("message");
                  controller.setNewBroker();
                },
                icon: (controller.connectionState.value)
                    ? Icon(Icons.link)
                    : Icon(Icons.link_off),
              );
            }),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .3,
              ),
              ListTile(
                title: Text("Dashboard"),
                subtitle: Text("Insight of live messages"),
                onTap: () {
                  Get.toNamed('/');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Subscribed"),
                subtitle: Text("Check which topics are subed"),
                onTap: () {
                  Get.toNamed('/');
                },
              ),
              ListTile(
                title: Text("Publish"),
                subtitle: Text("Publish to topic"),
                onTap: () {
                  Get.toNamed('/');
                },
              ),
              ListTile(
                title: Text("Exit"),
                subtitle: Text("See ya"),
                onTap: () {
                  Get.toNamed('/');
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'subscribe to topic',
                      labelText: '',
                    ),
                    controller: controller.subC,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      controller.subscribe();
                    },
                    child: Text("Sub"))
              ],
            ),
            // Obx(() => Text("msg -> ${controller.msges.toString()}")),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.msges.length,
                  itemBuilder: (BuildContext context, int index) {
                    return 
                    ListTile(  
                      title: Text(controller.msges[index]['topic']),  
                      subtitle:Text(controller.msges[index]['msg'])
                      
                      );
                  },
                ),
              );
            }),
          ],
        ));
  }
}

class MasterBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<MasterController>(() => MasterController());
    // Get.lazyPut<Api>(() => Api());
  }
}
