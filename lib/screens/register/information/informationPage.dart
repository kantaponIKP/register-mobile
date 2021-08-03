import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:register_demo/screens/register/information/personalPage.dart';
import 'package:register_demo/screens/register/information/takePhotoPage.dart';

import 'addressCurrentPage.dart';
import 'addressDeliveryOfDocumentsPage.dart';
import 'addressRegistrationPage.dart';

class InformationPage extends StatefulWidget {
  // InformationPage({Key key}): super(key: key);
  InformationPage(
      this.dataSink, this.pageSink, this.controllerPage, this.currentPage);

  final Sink<bool> dataSink;
  final Sink<int> pageSink;
  final StreamController<int> controllerPage;
  final int currentPage;

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  bool isFirstStageComplete = false;

  bool isVideoExist = false;

  int currentStep = 1;
  bool complete = true;
  StepperType stepperType = StepperType.horizontal;
  int page;
  StreamController<bool> controller = StreamController<bool>();
  StreamSubscription streamSubscription;

  // void initState() {
  //   super.initState();
  // }

  void initState() {
    super.initState();
    page = widget.currentPage;

    widget.controllerPage.stream.listen((event) {
      if (this.mounted) {

          // Your state change code goes here
          setState(() {
            print("---controllerPage Child Page---");
            print(event);
            page = event;
        });
      }
    });
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
    if (controller != null) {
      controller.close();
    }
    super.dispose();
  }

  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("---------------------------------------------VerifyPage change");
  //   // routeObserver.subscribe(this, ModalRoute.of(context));
  // }

  // void nextPage(){
  //     print("nextPage called");
  //    Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => InformationPage(widget.dataSink)),
  //     );
  // }

  // void setStage() {
  // print("setStage");
  // widget.dataSink.add(isFirstStageComplete);
  // widget.pageSink.add(page);
  // print("-----page----");
  // print(widget.pageSink);
  // print("page: "+page.toString());
  // }

  @override
  Widget build(BuildContext context) {
    print("page: " + page.toString());
    if (page == 1) {
      return TakePhotoPage(controller.sink);
    } else if (page == 2) {
      return PersonalPage(controller.sink);
    } else if (page == 3) {
      return AddressRegistrationPage(controller.sink);
    } else if (page == 4) {
      return AddressCurrentPage(controller.sink);
    } else if (page == 5) {
      return AddressDeliveryOfDocumentsPage(controller.sink);
    } else {
      return TakePhotoPage(controller.sink);
    }
  }
}
