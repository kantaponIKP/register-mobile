import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_demo/models/livenessCompareResponse.dart';
import 'package:register_demo/screens/register/cameraPage.dart';
import 'package:register_demo/services/livenessService.dart';
import 'package:register_demo/services/livenessStorage.dart';
import 'package:video_player/video_player.dart';
import 'package:register_demo/screens/dialogs.dart';

class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  PickedFile videoFile;
  String videoPath = 'assets/images/profile.png';
  bool isVideoExist = false;
  LivenessStorage livenessStorage;

  List<Step> steps = [
    Step(
      title: const Text('ยืนยันตัวตน'),
      // isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          // TextFormField(
          //   decoration: InputDecoration(labelText: 'Email Address'),
          // ),
          // TextFormField(
          //   decoration: InputDecoration(labelText: 'Password'),
          // ),
        ],
      ),
    ),
    Step(
      // isActive: true,
      state: StepState.indexed,
      title: const Text('ข้อมูลส่วนตัว'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Home Address'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Postcode'),
          ),
        ],
      ),
    ),
    Step(
      state: StepState.indexed,
      title: const Text('ตั้งรหัสผ่าน'),
      // subtitle: const Text("Error!"),
      content: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.red,
          )
        ],
      ),
    ),
  ];

  int currentStep = 1;
  bool complete = true;
  StepperType stepperType = StepperType.horizontal;

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void initState() {
    super.initState();
    livenessStorage = LivenessStorage.getInstance();
  }

  @override
  void dispose() {
    super.dispose();

    if (chewieController != null) {
      chewieController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.red,
      //       appBar: AppBar(
      //          iconTheme: IconThemeData(
      //   color: Colors.black38,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("ยืนยันตัวตน", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.red),
        centerTitle: true,
      ),
      //         // title: Text("Back",style: TextStyle(color: Colors.black38)),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      // ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          child: Stepper(
            type: stepperType,
            steps: steps,
            currentStep: currentStep,
            onStepContinue: next,
            onStepTapped: (step) => goTo(step),
            onStepCancel: cancel,
          ),
        ),
        Text("รูปภาพบัตรประจำตัวประชาชน"),
        Container(
          padding: EdgeInsets.only(
              left: screenSize.width * 0.1, right: screenSize.width * 0.1),
          child: Container(
            padding: EdgeInsets.all(screenSize.height * 0.08),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.redAccent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      onPhotoButtonPressed();
                    },
                    child: Container(
                      // padding: EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      // child: Center(
                      child: cameraWidget(context),
                    )),
              ],
            ),
          ),
        ),
        Text("วิดีโอหน้าตรง"),
        Container(
          padding: EdgeInsets.only(
              left: screenSize.width * 0.1, right: screenSize.width * 0.1),
          child: Container(
            padding: EdgeInsets.all(screenSize.height * 0.08),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.redAccent)),
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
        ),
      ]),

      // body: Stack(children: <Widget>[
      //   // Container(
      //   //   padding: EdgeInsets.only(top: 100),
      //   //   alignment: Alignment.topCenter,
      //   //   // child: Center(
      //   //   // child: Text("Take your photo",style: TextStyle(color: Colors.red,fontSize: 28,fontWeight: FontWeight.bold)),
      //   // ),
      //   GestureDetector(
      //       onTap: () {
      //         onPhotoButtonPressed();
      //       },
      //       child: Container(
      //         // padding: EdgeInsets.only(top: 100),
      //         alignment: Alignment.center,
      //         // child: Center(
      //         child: cameraWidget(context),
      //       )),
      //   GestureDetector(
      //       onTap: () {
      //         onVideoButtonPressed();
      //       },
      //       child: Container(
      //         padding: EdgeInsets.only(top: 100),
      //         alignment: Alignment.center,
      //         // child: Center(
      //         child: videoWidget(context),
      //       )),
      //   // ),

      //   // GestureDetector(
      //   //     onTap: () {
      //   //       onBackButtonPressed();
      //   //     },
      //   //     child: Container(
      //   //       alignment: Alignment.bottomLeft,
      //   //       padding:
      //   //           EdgeInsets.only(top: 60, bottom: 60, right: 60, left: 60),
      //   //       // margin: EdgeInsets.symmetric(horizontal: 4.0),
      //   //       child: Text("Back",
      //   //           style: TextStyle(color: Colors.red, fontSize: 22)),
      //   //     )),

      //   // Visibility(
      //   //   child: GestureDetector(
      //   //       onTap: () {
      //   //         onCompareButtonPressed();
      //   //       },
      //   //       child: Container(
      //   //         alignment: Alignment.bottomRight,
      //   //         padding:
      //   //             EdgeInsets.only(top: 60, bottom: 60, right: 50, left: 60),
      //   //         child: Text("Compare",
      //   //             style: TextStyle(color: Colors.blueAccent, fontSize: 22)),
      //   //       )),
      //   //   visible: isVideoExist,
      //   // ),
      // ]),
      bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
              onPressed: () {
                print("test");
              },
              // color: Colors.redAccent,
              // child: Text("ยืนยัน",
              //     style: TextStyle(fontSize: 16, color: Colors.white)))

              child: Text("ยืนยัน",
                  style: TextStyle(fontSize: 16, color: Colors.black38)))),
    );
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
      videoPlayerController: VideoPlayerController.file(File(videoFile.path)),
      // aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
      aspectRatio: 2 / 2,
      autoPlay: true,
      overlay: Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color.fromARGB(220, 0, 0, 0),
                height: 100,
              ))),
    );

    return chewieController;
  }

  Widget cameraWidget(BuildContext context) {
    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(0.0),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            new Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: videoFile == null
                        ? Container(
                            // padding: EdgeInsets.only(top: 300),
                            child: new CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 40.0,
                            child: new Icon(Icons.camera_alt,
                                color: Colors.white, size: 40),
                          ))
                        : Stack(fit: StackFit.loose, children: <Widget>[
                            FittedBox(
                                fit: BoxFit.contain,
                                child: mounted
                                    ? Chewie(controller: getChewieController())
                                    : Container()),
                          ]))
              ],
            ),
          ]),
        )
      ],
    );
  }

  Widget videoWidget(BuildContext context) {
    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(0.0),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            new Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: videoFile == null
                        ? Container(
                            // padding: EdgeInsets.only(top: 300),
                            child: new CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 40.0,
                            child: new Icon(Icons.videocam,
                                color: Colors.white, size: 40),
                          ))
                        :
                        // Center(heightFactor:10 ,child: Icon(Icons.videocam,color: Colors.red,size: 60.0,),):
                        // Text("test"):
                        Stack(fit: StackFit.loose, children: <Widget>[
                            FittedBox(
                                fit: BoxFit.contain,
                                child: mounted
                                    ? Chewie(controller: getChewieController())
                                    : Container()),
                            // Padding(
                            //     padding: EdgeInsets.only(top: 0, left: 0),
                            //     child: new Row(
                            //       // mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: <Widget>[
                            //         new CircleAvatar(
                            //           backgroundColor: Colors.red,
                            //           radius: 25.0,
                            //           child: new Icon(
                            //             Icons.camera_alt,
                            //             color: Colors.white,
                            //           ),
                            //         )
                            //       ],
                            //     )),
                          ]))
              ],
            ),
          ]),
        )
      ],
    );
  }

  onPhotoButtonPressed() {
    print("photo button pressed");
    activateCamera("photo");
  }

  onVideoButtonPressed() {
    print("video button pressed");
    activateCamera("video");
  }

  onCompareButtonPressed() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    // livenessStorage.setImageFile(videoFile);
    String imageBase64 = await livenessStorage
        .convertToBase64(File(livenessStorage.imageFile.path));
    File compressedVideoFile =
        await livenessStorage.compressVideo(File(videoFile.path));

    String videoBase64 =
        await livenessStorage.convertToBase64(compressedVideoFile);

    final responseLivenessSevice = await LivenessService.silent(
        imageBase64: imageBase64, videoBase64: videoBase64);

    log("----------Map Json-----------");
    LivenessCompareResponse livenessCompareResponse =
        LivenessCompareResponse.fromJson(
            json.decode(responseLivenessSevice.body));
    // final Map parsed = json.decode(response.body);
    // LivenessCompareResponse livenessCompareResponse = LivenessCompareResponse.fromJson(parsed);
    log("----------------------");
    log(livenessCompareResponse.toString());
    log("----------------------");
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    // log(livenessCompareResponse.response.error.message.toString());
    // log(livenessCompareResponse.response.result);

    // if (livenessCompareResponse.error != ""){
    //   showAlertDialog(context,"Error",livenessCompareResponse.error);
    // }

    // ErrorResponse error = new ErrorResponse(code: "", message: "");
    // Response response = new Response(
    //     result: "Test",
    //     description: "",
    //     sim: 0,
    //     bestFrameBase64: "",
    //     requestId: "",
    //     error: error);

    // livenessStorage.livenessCompareResponse =  new LivenessCompareResponse(response: response);
    livenessStorage.livenessCompareResponse = livenessCompareResponse;
    try {
      String hasResult =
          livenessStorage.livenessCompareResponse.response.result;
      log("hasResult: " + hasResult);
      if (hasResult != "") {
        log("Result: " +
            livenessStorage.livenessCompareResponse.response.result);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showAlertDialog(
            context,
            "Error",
            livenessCompareResponse.response.error.code +
                "\n" +
                livenessCompareResponse.response.error.message);
      }
    } catch (error) {
      showAlertDialog(
          context,
          "Error",
          livenessCompareResponse.response.error.code +
              "\n" +
              livenessCompareResponse.response.error.message);
    }

    print("next button pressed");
  }

  onBackButtonPressed() {
    print("back button pressed");
    Navigator.pop(context);
  }

  ImagePicker imagePicker = ImagePicker();

  activateCamera(String source) async {
    // var video
    // PickedFile video

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
      PickedFile video;
    } else if (source == "video") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CameraApp(isPhoto: false)));
      PickedFile video;
    }

    // PickedFile video = await imagePicker.getVideo(
    //   source: ImageSource.camera,
    //   preferredCameraDevice: CameraDevice.front,
    // );

    // if (video != null) {
    //   setState(() {
    //     videoFile = video;
    //     videoPath = video.path;
    //     isVideoExist = true;
    //   });
    // }
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
        onCompareButtonPressed();
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
            fontSize: 30.0,
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
}
