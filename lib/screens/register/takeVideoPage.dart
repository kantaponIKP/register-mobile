import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_demo/models/livenessCompareResponse.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/screens/register/cameraPage.dart';
import 'package:register_demo/services/googleVisionService.dart';
import 'package:register_demo/services/livenessService.dart';
import 'package:register_demo/services/livenessStorage.dart';
import 'package:register_demo/services/registerStorage.dart';
import 'package:video_player/video_player.dart';
import 'package:register_demo/screens/dialogs.dart';

// import '../informationPage.dart';

class TakeVideoPage extends StatefulWidget {
  TakeVideoPage(this.dataSink);
  // nextPage() => createState().nextPage();
  final Sink<bool> dataSink;
  
  
  

  @override
  _TakeVideoPageState createState() => _TakeVideoPageState();
  
}

class _TakeVideoPageState extends State<TakeVideoPage> {
  bool isFirstStageComplete = false;
  // String videoPath = 'assets/images/profile.png';
  String videoPath;
  bool isVideoExist = false;
  LivenessStorage livenessStorage;

  RegisterStorage registerStorage;
  File photoFile;
  File _photoFile;
  File _videoFile;

  GoogleVisionService googleVisionService;

  int currentStep = 1;
  bool complete = true;
  StepperType stepperType = StepperType.horizontal;

  Color primaryColor = Colors.red[700];

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void initState() {
    super.initState();
    livenessStorage = LivenessStorage.getInstance();
    registerStorage = RegisterStorage.getInstance();
    googleVisionService = new GoogleVisionService();
    registerStorage.initialPerson();
    setupPage();
  }

  @override
  void dispose() {
    super.dispose();

    if (chewieController != null) {
      chewieController.dispose();
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    print("---------------------------------------------VerifyPage change");
    // routeObserver.subscribe(this, ModalRoute.of(context));
  }

  // void nextPage(){
  //     print("nextPage called");
  //    Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => InformationPage(widget.dataSink)),
  //     );
  // }
  


  void setupPage() {
    if (registerStorage.imageFile != null &&
        registerStorage.videoFile != null) {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
    }
  }
  

  void setStage() {
    // print("------------------SET STAGE--------------");
    // if ((registerStorage.imageFile != null) &&
    //     (registerStorage.videoFile != null)) {
    //   isFirstStageComplete = true;
    // } else {
    //   isFirstStageComplete = false;
    // }
    // widget.dataSink.add(isFirstStageComplete);
    // widget.dataSink.add(isFirstStageComplete);
  }
  

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double fontSize;
    if (screenSize.width > 600) {
      fontSize = 18;
    } else {
      fontSize = 15;
    }
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
          padding: EdgeInsets.all(10),
          child: AutoSizeText(
            'เตรียมการถ่ายวิดีโอ',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            maxLines: 1,
          )),
      Container(
          padding: EdgeInsets.only(
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
          ),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            Container(
              height: screenSize.width * 0.4915,
              decoration: BoxDecoration(border: Border.all(color: primaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        onVideoButtonPressed();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: videoWidget(context),
                      )),
                ],
              ),
            ),
            _videoFile == null
                ? Container()
                : Positioned(
                    right: 8,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: () {
                        onVideoButtonPressed();
                      },
                      child: Container(
                          color: Colors.black38,
                          child: Row(children: [
                            Container(
                                child: Container(
                                    padding: EdgeInsets.all(1),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ))),
                            Container(
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text(
                                "ถ่ายอีกครั้ง",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ])),
                    ),
                  ),
          ])),
    ]);
  }

  ChewieController chewieController = null;

  ChewieController getChewieController() {
    if (chewieController != null &&
        chewieController.videoPlayerController != null) {
      chewieController.videoPlayerController.dispose();
    }

    chewieController = ChewieController(
        showControls: true,
        looping: true,
        // videoPlayerController: VideoPlayerController.file(File(videoFile.path)),
        videoPlayerController:
            VideoPlayerController.file(File(
              registerStorage.videoPath
              )),
        aspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        // aspectRatio: 2 / 2,
        autoPlay: true,
        overlay:
            // Expanded(
            // child:
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color.fromARGB(220, 0, 0, 0),
                  height: 0,
                ))
        // ),
        );

    return chewieController;
  }

  Widget videoWidget(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return _videoFile == null
        ? CircleAvatar(
            backgroundColor: primaryColor,
            radius: screenSize.height * 0.05,
            child: new Icon(Icons.videocam,
                color: Colors.white, size: screenSize.height * 0.05),
          )
        : Stack(fit: StackFit.loose, children: <Widget>[
            FittedBox(
                fit: BoxFit.contain,
                child: mounted
                    ? Chewie(controller: getChewieController())
                    : Container()),
          ]);
  }

  onIdentificationCardButtonPressed() async {
    print("photo button pressed");
    await activateIdentificationCardCamera();
    setStage();
    Person person = await googleVisionService
        .getIdentificationCardExtractedData(_photoFile);
    registerStorage.setPerson(person);
  }

  onDriverLicenseButtonPressed() async {
    print("photo button pressed");
    await activateDriverLicenseCamera();
    Person person =
        await googleVisionService.getDrivingLicenseExtractedData(_photoFile);
    setStage();
    registerStorage.setPerson(person);
  }

  onPassportButtonPressed() async {
    print("photo button pressed");
    await activatePassportCamera();
    Person person =
        await googleVisionService.getPassportExtractedData(_photoFile);
    setStage();
    registerStorage.setPerson(person);
  }

  onVideoButtonPressed() async {
    print("video button pressed");
    await activateVideoCamera();
    setStage();
  }

  // onCompareButtonPressed() async {
  //   Dialogs.showLoadingDialog(context, _keyLoader);
  //   // livenessStorage.setImageFile(videoFile);
  //   String imageBase64 = await livenessStorage
  //       .convertToBase64(File(livenessStorage.imageFile.path));
  //   File compressedVideoFile =
  //       // await livenessStorage.compressVideo(File(videoFile.path));
  //       await livenessStorage.compressVideo(File(videoPath));

  //   String videoBase64 =
  //       await livenessStorage.convertToBase64(compressedVideoFile);

  //   final responseLivenessSevice = await LivenessService.silent(
  //       imageBase64: imageBase64, videoBase64: videoBase64);

  //   log("----------Map Json-----------");
  //   LivenessCompareResponse livenessCompareResponse =
  //       LivenessCompareResponse.fromJson(
  //           json.decode(responseLivenessSevice.body));
  //   // final Map parsed = json.decode(response.body);
  //   // LivenessCompareResponse livenessCompareResponse = LivenessCompareResponse.fromJson(parsed);
  //   log("----------------------");
  //   log(livenessCompareResponse.toString());
  //   log("----------------------");
  //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

  //   // log(livenessCompareResponse.response.error.message.toString());
  //   // log(livenessCompareResponse.response.result);

  //   // if (livenessCompareResponse.error != ""){
  //   //   showAlertDialog(context,"Error",livenessCompareResponse.error);
  //   // }

  //   // ErrorResponse error = new ErrorResponse(code: "", message: "");
  //   // Response response = new Response(
  //   //     result: "Test",
  //   //     description: "",
  //   //     sim: 0,
  //   //     bestFrameBase64: "",
  //   //     requestId: "",
  //   //     error: error);

  //   // livenessStorage.livenessCompareResponse =  new LivenessCompareResponse(response: response);
  //   livenessStorage.livenessCompareResponse = livenessCompareResponse;
  //   try {
  //     String hasResult =
  //         livenessStorage.livenessCompareResponse.response.result;
  //     log("hasResult: " + hasResult);
  //     if (hasResult != "") {
  //       log("Result: " +
  //           livenessStorage.livenessCompareResponse.response.result);
  //       // Navigator.popUntil(context, (route) => route.isFirst);
  //     } else {
  //       showAlertDialog(
  //           context,
  //           "Error",
  //           livenessCompareResponse.response.error.code +
  //               "\n" +
  //               livenessCompareResponse.response.error.message);
  //     }
  //   } catch (error) {
  //     showAlertDialog(
  //         context,
  //         "Error",
  //         livenessCompareResponse.response.error.code +
  //             "\n" +
  //             livenessCompareResponse.response.error.message);
  //   }

  //   print("next button pressed");
  // }

  onBackButtonPressed() {
    print("back button pressed");
    Navigator.pop(context);
  }

  ImagePicker imagePicker = ImagePicker();

  activateCamera(String source) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    if (source == "photo") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CameraApp(isPhoto: true)));
    } else if (source == "video") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CameraApp(isPhoto: false)));
    }
    print("photoFile: " + registerStorage.imageFile.toString());
    setState(() {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
      videoPath = registerStorage.videoPath;
    });
  }

  activateIdentificationCardCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CameraApp(
                  isPhoto: true,
                  isIdentificationCard: true,
                )));
    setState(() {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
      videoPath = registerStorage.videoPath;
    });
  }

  activateDriverLicenseCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CameraApp(
                  isPhoto: true,
                  isDriverLicense: true,
                )));
    setState(() {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
      videoPath = registerStorage.videoPath;
    });
  }

  activatePassportCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CameraApp(
                  isPhoto: true,
                  isPassport: true,
                )));
    setState(() {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
      videoPath = registerStorage.videoPath;
    });
  }

  activateVideoCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CameraApp(isVideo: true)));

    setState(() {
      _photoFile = registerStorage.imageFile;
      _videoFile = registerStorage.videoFile;
      videoPath = registerStorage.videoPath;
    });
  }

  // showAlertDialog(BuildContext context, String title, String body) {
  //   Widget retryButton = FlatButton(
  //     child: Text("Retry",
  //         style: TextStyle(
  //           color: Colors.red,
  //           fontWeight: FontWeight.bold,
  //         )),
  //     onPressed: () {
  //       Navigator.pop(context);
  //       onCompareButtonPressed();
  //     },
  //   );
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel",
  //         style: TextStyle(
  //           color: Colors.black38,
  //         )),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     title: Text(title,
  //         style: TextStyle(
  //           color: Colors.red,
  //           fontSize: 30.0,
  //         )),
  //     content: Text(body),
  //     actions: [
  //       cancelButton,
  //       retryButton,
  //     ],
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
