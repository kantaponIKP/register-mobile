import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:register_demo/models/livenessCompareResponse.dart';
import 'package:register_demo/models/responseData.dart';
import 'package:register_demo/screens/register/informationPage.dart';
import 'package:register_demo/screens/register/settingUserPage.dart';
import 'package:register_demo/screens/register/verifyIdentityPage.dart';
import 'package:register_demo/services/livenessService.dart';
import 'package:register_demo/services/livenessStorage.dart';
import 'package:register_demo/services/registerService.dart';
import 'package:register_demo/services/registerStorage.dart';
import 'package:register_demo/screens/dialogs.dart';
import 'package:register_demo/screens/register/registerThird.dart';

class StepperPage extends StatefulWidget {
  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int currentStep = 0;
  bool complete = false;
  List<Step> steps;
  StepperType stepperType = StepperType.horizontal;
  RegisterStorage registerStorage;
  LivenessStorage livenessStorage;

  String videoPath = 'assets/images/profile.png';

  bool isFirstStageComplete = false;
  bool isSecondStageComplete = false;
  bool isThirdStageComplete = false;

  List<String> title = ["ยืนยันตัวตน", "ข้อมูลส่วนตัว", "ตั้งรหัสผ่าน"];

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  StreamController<bool> controller = StreamController<bool>();
  StreamSubscription streamSubscription;

  LivenessCompareResponse livenessCompareResponse;

  ResponseData responseData;
  String diglogText = '';
  String _diglogText = '';

  nextStep() {
    print("steps : " + steps.toString());
    print("steps.length : " + steps.length.toString());
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancelStep() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  void initState() {
    super.initState();
    registerStorage = RegisterStorage.getInstance();
    livenessStorage = LivenessStorage.getInstance();
    controller.stream.listen((event) {
      setState(() {
        if (currentStep == 0) {
          isFirstStageComplete = event;
        } else if (currentStep == 1) {
          isSecondStageComplete = event;
        } else if (currentStep == 2) {
          isThirdStageComplete = event;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setStage();
    print("--------------------------Stepper Page change");
    // routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    steps = [
      Step(
        title: const Text('ยืนยันตัวตน'),
        state: getStepState(0, currentStep),
        isActive: getIsActive(0, currentStep),
        content: Column(
          children: <Widget>[VerifyIdentityPage(controller.sink)],
        ),
      ),
      Step(
        title: const Text('ข้อมูลส่วนตัว'),
        state: getStepState(1, currentStep),
        isActive: getIsActive(1, currentStep),
        content: Column(
          children: <Widget>[InformationPage(controller.sink)],
        ),
      ),
      Step(
        title: const Text('สร้างบัญชี'),
        state: getStepState(2, currentStep),
        isActive: getIsActive(2, currentStep),
        // subtitle: const Text("Error!"),
        content: Column(
          children: <Widget>[SettingUserPage(controller.sink)],
        ),
      ),
    ];

    // final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        minimum: const EdgeInsets.only(bottom: 45),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title:
                Text(title[currentStep], style: TextStyle(color: Colors.black)),
            iconTheme: IconThemeData(color: Colors.red),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => backNavigator(),
            ),
          ),
          body: Stepper(
            type: stepperType,
            steps: steps,
            currentStep: currentStep,
            onStepContinue: nextStep,
            // onStepTapped: (step) => goTo(step),
            onStepCancel: cancelStep,
            controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
          ),
          bottomNavigationBar: isStageComplete()
              ? BottomAppBar(
                  child: RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        onConfirmButtonPressed();
                      },
                      child: Text("ยืนยัน",
                          style: TextStyle(fontSize: 16, color: Colors.white))))
              : BottomAppBar(
                  child: RaisedButton(
                      onPressed: () {
                        onConfirmButtonPressed();
                      },
                      child: Text("ยืนยัน",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black38)))),
        ));
  }

  Widget bottomSheet(BuildContext context) {
    return Icon(Icons.add);
  }

  backNavigator() {
    if (currentStep == 0) {
      Navigator.pop(context);
    } else if (currentStep == 1) {
      cancelStep();
    } else if (currentStep == 2) {
      cancelStep();
    }
  }

  onConfirmButtonPressed() async {
    if (currentStep == 0) {
      await livenessCompare();
      print("register Stepper: " + registerStorage.person.idno);
      print("livenessStorage.livenessCompareResponse.response.result: " +
          livenessStorage.livenessCompareResponse.response.result);
      if (livenessStorage.livenessCompareResponse.response.result ==
          "Success") {
            // if (true == true) {
        showSuccessDialog(context);
        nextStep();
      } else if (livenessStorage.livenessCompareResponse.response.result ==
          "FailedOperation.SilentDetectFail") {
        showAlertDialog(
            context,
            "ยืนยันตัวตนไม่สำเร็จ",
            "ใบหน้าไม่ตรงกัน" +
                "\n" +
                "ค่าความเหมือนของใบหน้าคือ " +
                livenessCompareResponse.response.sim);
      } else if (livenessStorage.livenessCompareResponse.response.result ==
          "FailedOperation.SilentThreshold") {
        showAlertDialog(
            context,
            "ยืนยันตัวตนไม่สำเร็จ",
            "การตรวจจับบุคคลไม่ผ่านมาตรฐาน" +
                "\n" +
                livenessCompareResponse.response.error.message);
      } else {
        showAlertDialog(
            context,
            "ยืนยันตัวตนไม่สำเร็จ",
            "การตรวจจับบุคคลล้มเหลว" +
                "\n" +
                livenessCompareResponse.response.error.message);
      }
    } else if (currentStep == 1) {
      nextStep();
    } else if (currentStep == 2) {
      bool isCompleted = await registerKeycloak();
      if (isCompleted) {
        nextStep();
      }
    }
  }

  livenessCompare() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    // livenessStorage.setImageFile(videoFile);
    String imageBase64 = await livenessStorage
        .convertToBase64(File(registerStorage.imageFile.path));
    File compressedVideoFile =
        // await livenessStorage.compressVideo(File(videoFile.path));
        await livenessStorage.compressVideo(File(registerStorage.videoPath));

    String videoBase64 =
        await livenessStorage.convertToBase64(compressedVideoFile);

    final responseLivenessSevice = await LivenessService.silent(
        imageBase64: imageBase64, videoBase64: videoBase64);

    log("----------Map Json-----------");
    livenessCompareResponse = LivenessCompareResponse.fromJson(
        json.decode(responseLivenessSevice.body));
    log("----------------------");
    log(livenessCompareResponse.toString());
    log("----------------------");
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    livenessStorage.livenessCompareResponse = livenessCompareResponse;
    try {
      String hasResult =
          livenessStorage.livenessCompareResponse.response.result;
      log("hasResult: " + hasResult);
      if (hasResult != "") {
        log("Result: " +
            livenessStorage.livenessCompareResponse.response.result);
        // Navigator.popUntil(context, (route) => route.isFirst);

        // showAlertDialog(context,livenessCompareResponse.response.result,responseLivenessSevice.body);
      } else {
        // showAlertDialog(
        //     context,
        //     "Error",
        //     livenessCompareResponse.response.error.code +
        //         "\n" +
        //         livenessCompareResponse.response.error.message);
      }
    } catch (error) {
      // showAlertDialog(
      //     context,
      //     "Error",
      //     livenessCompareResponse.response.error.code +
      //         "\n" +
      //         livenessCompareResponse.response.error.message);
    }

    print("next button pressed");
  }

  Future<bool> registerKeycloak() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    log("register");
    String username = registerStorage.person.username;
    String email = registerStorage.person.email;

    // Post API
    final response = await RegisterService.postRequest(
        username, email, registerStorage.person);
    log((response != null).toString());
    log((response).toString());
    if (response != null) {
      log("---log---");
      log("Status code: " + response.statusCode.toString());
      log("body : " + response.body);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      try {
        responseData = ResponseData.fromJson(json.decode(response.body));

        if (response.statusCode == 201) {
          // To do

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RegisterThirdPage(url: responseData.url)));
          return true;
        } else if (response.statusCode == 409) {
          if (responseData.error == "User already exists!") {
            diglogText = 'Username ถูกใช้งานแล้ว กรุณากรอกใหม่อีกครั้ง';
          } else if (responseData.error == "Email already exists!") {
            diglogText = 'Email ถูกใช้งานแล้ว กรุณากรอกใหม่อีกครั้ง';
          } else {
            diglogText = 'กรุณาลองใหม่อีกครั้ง';
          }
        } else {
          diglogText = 'กรุณาลองใหม่อีกครั้ง';
        }
      } catch (e) {
        diglogText = 'กรุณาลองใหม่อีกครั้ง';
      }
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      diglogText = 'เนื่องจากระยะเวลารอเกินกำหนด';
    }

    setState(() {
      _diglogText = diglogText;
    });

    showResponseAlertDialog(context);

    return false;
  }

  void setStage() {
    if ((registerStorage.imageFile != null) &&
        (registerStorage.videoFile != null)) {
      isFirstStageComplete = true;
    } else {
      isFirstStageComplete = false;
    }
  }

  bool isStageComplete() {
    bool isStageComplete;
    if (currentStep == 0) {
      if (isFirstStageComplete == true) {
        isStageComplete = true;
      } else {
        isStageComplete = false;
      }
    } else if (currentStep == 1) {
      if (isSecondStageComplete == true) {
        isStageComplete = true;
      } else {
        isStageComplete = false;
      }
    } else if (currentStep == 2) {
      if (isThirdStageComplete == true) {
        isStageComplete = true;
      } else {
        isStageComplete = false;
      }
    } else {
      isStageComplete = false;
    }
    return isStageComplete;
  }

  showResponseAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("ตกลง",
          style: TextStyle(
            color: Colors.red,
            // fontSize: 15.0,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("การลงทะเบียนไม่สำเร็จ",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
          )),
      content: Text(_diglogText),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, String title, String body) {
    Widget retryButton = FlatButton(
      child: Text("Retry",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          )),
      onPressed: () {
        Navigator.pop(context);
        // onCompareButtonPressed();
        onConfirmButtonPressed();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel",
          style: TextStyle(
            color: Colors.black38,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
          )),
      content: Text(body),
      actions: [
        cancelButton,
        retryButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSuccessDialog(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      // if()
      Navigator.of(context).pop(context);
    });
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันตัวตนสำเร็จ",
      textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 20.0,
          )),
      content:
      Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.greenAccent,  width: 3)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(Icons.check, size: 60,color: Colors.greenAccent,),
            ),
          )
    );

    
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },child:alert);
      },
    );
  }
}

bool getIsActive(int currentIndex, int index) {
  if (currentIndex == index) {
    return true;
  } else {
    return false;
  }
}

StepState getStepState(int currentIndex, int index) {
  StepState stepState;
  if (currentIndex < index) {
    stepState = StepState.complete;
  } else {
    stepState = StepState.indexed;
  }
  return stepState;
}
