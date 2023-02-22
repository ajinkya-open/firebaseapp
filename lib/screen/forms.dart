
import 'package:firebaseapp/screen/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeFormPage extends GetView<MasterController> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(title: Text('SubscribeFormPage')),

    body: SafeArea(
      child: Text('SubscribeFormController'))
    );
  }
}