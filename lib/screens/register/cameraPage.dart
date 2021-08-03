import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:register_demo/screens/register/previewPhoto.dart';
import 'package:register_demo/services/registerStorage.dart';
import 'package:video_player/video_player.dart';

List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  final bool isPhoto;
  final bool isVideo;
  final bool isIdentificationCard;
  final bool isDriverLicense;
  final bool isPassport;
  const CameraApp(
      {Key key,
      this.isPhoto,
      this.isVideo,
      this.isIdentificationCard,
      this.isDriverLicense,
      this.isPassport})
      : super(key: key);

  @override
  _CameraAppState createState() {
    return _CameraAppState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  /// Display the preview from the camera (or a message if the preview is not available).

  RegisterStorage registerStorage;
  bool isPhoto = false;
  bool isVideo = false;
  bool isIdentificationCard = false;
  bool isDriverLicense = false;
  bool isPassport = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timer != null) {
      timer.cancel();
    }
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    registerStorage = RegisterStorage.getInstance();

    cameraSetUp();
    WidgetsBinding.instance.addObserver(this);

    setValue();

    super.initState();
    if (widget.isPhoto == true) {
      controller = CameraController(
          cameraBackDescription, ResolutionPreset.medium,
          enableAudio: false);
    } else if (widget.isVideo == true) {
      controller = CameraController(
          cameraFrontDescription, ResolutionPreset.medium,
          enableAudio: false);
    }

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    super.initState();
  }

  setValue() {
    if (widget.isPhoto != null) {
      isPhoto = widget.isPhoto;
    }
    if (widget.isVideo != null) {
      isVideo = widget.isVideo;
    }
    if (widget.isIdentificationCard != null) {
      isIdentificationCard = widget.isIdentificationCard;
    }
    if (widget.isDriverLicense != null) {
      isDriverLicense = widget.isDriverLicense;
    }
    if (widget.isPassport != null) {
      isPassport = widget.isPassport;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isPhoto) {
      if (isIdentificationCard) {
        return photoIdentificationCardWidget();
      } else if (isDriverLicense) {
        return photoDrivingLicenseWidget();
      } else if (isPassport) {
        return photoPassportWidget();
      }
    } else if (isVideo) {
      return videoWidget();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red),
          centerTitle: true,
        ),
        body: Center(child: Text("Sorry, something went wrong.")));
  }

  // Widget checkPhotoWidget(){
  //   return Scaffold(
  //     body: Column(children: <Widget>[

  //     ],)
  //   );
  // }

  //   Widget checkPhotoWidget(){
  //   return Scaffold(
  //     body: Column(children: <Widget>[

  //     ],)
  //   );
  // }

  Widget photoIdentificationCardWidget() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 40,
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('/register')),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0, right: 1.0, left: 1.0),
                child: Center(
                    child: Stack(children: <Widget>[
                  _cameraIdentificationCardPreviewWidget(),
                ])
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  _takePhotoWidget(),
                  _switchCameraWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget photoDrivingLicenseWidget() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 40,
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('/register')),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0, right: 1.0, left: 1.0),
                child: Center(
                    child: Stack(children: <Widget>[
                  _cameraDrivingLicensePreviewWidget(),
                ])),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  _takePhotoWidget(),
                  _switchCameraWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget photoPassportWidget() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 40,
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('/register')),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0, right: 1.0, left: 1.0),
                child: Center(
                    child: Stack(children: <Widget>[
                  _cameraPassportPreviewWidget(),
                ])),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  _takePhotoWidget(),
                  _switchCameraWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget videoWidget() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 40,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          //  _backWidget(),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                // child: Center(
                  child: _cameraPreviewWidget(),
                // ),
              ),
              // decoration: BoxDecoration(
              //   color: Colors.black,
              // ),
            ),
          ),

          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // _captureControlRowWidget(),
                  Spacer(),
                  _takeVideoWidget(),
                  _switchCameraWidget(),
                  // _cameraTogglesRowWidget(),
                  // _thumbnailWidget(),
                ],
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: countdownTime,
      //   tooltip: 'Toggle',
      // )
    );
  }

  // /// Display a row of toggle to select the camera (or a message if no camera is available).
  // Widget _cameraTogglesRowWidget() {
  //   final List<Widget> toggles = <Widget>[];

  //   if (cameras.isEmpty) {
  //     return const Text('No camera found');
  //   } else {
  //     for (CameraDescription cameraDescription in cameras) {
  //       toggles.add(
  //         SizedBox(
  //           width: 90.0,
  //           child: RadioListTile<CameraDescription>(
  //             title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
  //             groupValue: controller?.description,
  //             value: cameraDescription,
  //             onChanged: controller != null && controller.value.isRecordingVideo
  //                 ? null
  //                 : onNewCameraSelected,
  //           ),
  //         ),
  //       );
  //     }
  //   }

  //   return Row(children: toggles);
  // }

  CameraDescription cameraBackDescription;
  CameraDescription cameraFrontDescription;
  CameraController controller;
  bool enableAudio = false;
  String imagePath;
  VideoPlayerController videoController;
  String videoPath;
  VoidCallback videoPlayerListener;
  Timer timer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  Widget _backWidget() {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Spacer(),
            // _takeVideoWidget(),
            // _switchCameraWidget(),
          ],
        ),
      ),
    );
    // return Opacity(
    //   opacity: 1,
    //   child: Container(
    //     height: 500.0,
    //     width: 500.0,
    //     color: Colors.red,
    //     // color: Colors.transparent,
    //   ),
    // );
  }

  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size.width;
    return (!controller.value.isInitialized)
        ? new Container()
        : AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            // aspectRatio: 3.0 / 4.0,
            child: CameraPreview(controller),
          );
  }

  Widget _cameraIdentificationCardPreviewWidget() {
    final size = MediaQuery.of(context).size.width;

    try {
      controller.debugCheckIsDisposed();
      return new Container();
    } catch (_) {}

    // return (!controller.value.isInitialized)
    //     ? new Container()
    //     // : AspectRatio(
    //     //     // aspectRatio: controller.value.aspectRatio,
    //     //     aspectRatio: 3.0 / 4.0,
    //     //     child: CameraPreview(controller),
    //     //   );
    //     : Transform.scale(
    //         scale: 1.0,
    //         child: AspectRatio(
    //           aspectRatio: 3.0 / 4.0,
    //           child: OverflowBox(
    //             alignment: Alignment.center,
    //             child: FittedBox(
    //               fit: BoxFit.fitWidth,
    //               child: Container(
    //                 width: size,
    //                 height: size / controller.value.aspectRatio,
    //                 child: Stack(
    //                   children: <Widget>[
    //                     CameraPreview(controller),
    //                     _identificationCardLayoutWidget()
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );

     return (!controller.value.isInitialized)
        ? new Container()
        // : AspectRatio(
        //     // aspectRatio: controller.value.aspectRatio,
        //     aspectRatio: 3.0 / 4.0,
        //     child: CameraPreview(controller),
        //   );
        : Transform.scale(
            scale: 1,
            child: AspectRatio(
              aspectRatio: 3.0 / 4.0,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    // width: size/controller.value.aspectRatio,
                    width: size,
                    height: size,
                    // height: size / controller.value.aspectRatio,
                    child: Stack(
                      children: <Widget>[
                        Center(child: 
                        CameraPreview(controller),
                        ),
                        _identificationCardLayoutWidget()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _cameraDrivingLicensePreviewWidget() {
    final size = MediaQuery.of(context).size.width;
    return (!controller.value.isInitialized)
        ? new Container()
        : Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: 3.0 / 4.0,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    width: size,
                    height: size / controller.value.aspectRatio,
                    child: Stack(
                      children: <Widget>[
                        CameraPreview(controller),
                        _drivingLicenseLayoutWidget()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _cameraPassportPreviewWidget() {
    final size = MediaQuery.of(context).size.width;
    return (!controller.value.isInitialized)
        ? new Container()
        : Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: 3.0 / 4.0,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    width: size,
                    height: size / controller.value.aspectRatio,
                    child: Stack(
                      children: <Widget>[
                        CameraPreview(controller),
                        _passportLayoutWidget()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _identificationCardLayoutWidget() {
    return (!controller.value.isInitialized)
        ? new Container()
        : Opacity(
            opacity: 0.5,
            child: Image(
              image: AssetImage('assets/images/identificationCardLayout.png'),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ));
  }

  Widget _drivingLicenseLayoutWidget() {
    return (!controller.value.isInitialized)
        ? new Container()
        : Opacity(
            opacity: 0.5,
            child: Image(
              image: AssetImage('assets/images/drivingLicenseLayout.png'),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ));
  }

  Widget _passportLayoutWidget() {
    return (!controller.value.isInitialized)
        ? new Container()
        : Opacity(
            opacity: 0.5,
            child: Image(
              image: AssetImage('assets/images/passportLayout.png'),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ));
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (controller != null) {
                onNewCameraSelected(controller.description);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _takePhotoWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 5, color: Colors.white)),
              child: IconButton(
                  icon: !controller.value.isRecordingVideo
                      ? const Icon(Icons.circle)
                      : const Icon(Icons.stop),
                  iconSize: 40.0,
                  color: Colors.white,
                  onPressed: onTakePictureButtonPressed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _takeVideoWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 5, color: Colors.white)),
              child: IconButton(
                  icon: !controller.value.isRecordingVideo
                      ? const Icon(Icons.circle)
                      : const Icon(Icons.stop),
                  iconSize: 40.0,
                  color: Colors.redAccent,
                  onPressed: onVideoRecordButtonPressed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchCameraWidget() {
    if ((cameras.length >= 2) && !controller.value.isRecordingVideo) {
      return Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: const Icon(Icons.sync),
                  iconSize: 40.0,
                  color: Colors.white,
                  onPressed: onSwitchCameraButtonPress),
            ],
          ),
        ),
      );
    } else {
      return Spacer();
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
                    child: (videoController == null)
                        ? Image.file(File(imagePath))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.size != null
                                          ? videoController.value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(videoController)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
// crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
      children: <Widget>[
        // IconButton(
        //   icon: const Icon(Icons.camera_alt),
        //   color: Colors.blue,
        //   onPressed: controller != null &&
        //           controller.value.isInitialized &&
        //           !controller.value.isRecordingVideo
        //       ? onTakePictureButtonPressed
        //       : null,
        // ),
        IconButton(
          icon: const Icon(Icons.circle),
          // icon: const Icon(Icons.videocam),
          color: Colors.white,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.sync),
          // icon: const Icon(Icons.videocam),
          color: Colors.white,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),

        // IconButton(
        //   icon: controller != null && controller.value.isRecordingPaused
        //       ? Icon(Icons.play_arrow)
        //       : Icon(Icons.pause),
        //   color: Colors.blue,
        //   onPressed: controller != null &&
        //           controller.value.isInitialized &&
        //           controller.value.isRecordingVideo
        //       ? (controller != null && controller.value.isRecordingPaused
        //           ? onResumeButtonPressed
        //           : onPauseButtonPressed)
        //       : null,
        // ),
        // IconButton(
        //   icon: const Icon(Icons.stop),
        //   color: Colors.red,
        //   onPressed: controller != null &&
        //           controller.value.isInitialized &&
        //           controller.value.isRecordingVideo
        //       ? onStopButtonPressed
        //       : null,
        // ),
        // IconButton(
        //     icon: const Icon(Icons.check),
        //     color: Colors.blue,
        //     onPressed:
        //         // (imagePath != null) && controller != null &&
        //         //         controller.value.isInitialized
        //         //     ? onReturnButtonPressed
        //         //     : null,
        //         onReturnButtonPressed)
      ],
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void cameraSetUp() {
    for (CameraDescription cameraDescription in cameras) {
      print(cameraDescription.lensDirection);
      if (cameraDescription.lensDirection == CameraLensDirection.front) {
        cameraFrontDescription = cameraDescription;
        break;
      }
    }
    for (CameraDescription cameraDescription in cameras) {
      if (cameraDescription.lensDirection == CameraLensDirection.back) {
        cameraBackDescription = cameraDescription;
        break;
      }
    }
  }

  void countdownTime() {
    int timeCounter = 3;
    timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      print('timer $timeCounter');
      if (timeCounter < 1) {
        timer.cancel();
        stopAndReturnVideo();
      } else {
        timeCounter = timeCounter - 1;
      }
    });
  }

  void returnToRegisterPage(String path) {
    registerStorage.setVideoFile(File(path));
    registerStorage.setVideoPath(path);
    print("***********Return*********");
    Navigator.popUntil(context, ModalRoute.withName('/register'));
  }

  Future<void> onSwitchCameraButtonPress() async {
    print("OnSwitchCameraButtonPress");
    // CameraLensDirection.back;

    print("---Camera---");
    print(controller.description);

    print(cameraFrontDescription);
    print(cameraBackDescription);

    if (controller.description == cameraFrontDescription) {
      if (controller != null) {
        await controller.dispose();
      }

      controller = CameraController(
        cameraBackDescription,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    } else if (controller.description == cameraBackDescription) {
      if (controller != null) {
        await controller.dispose();
      }

      controller = CameraController(
        cameraFrontDescription,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    }

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    print(
        "------------------------------------------------camera select: $cameraDescription");
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      // enableAudio: enableAudio,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    print("OnTakePicturePress****");
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PreviewPhoto(path: filePath)));
      }
    });
  }

  void onVideoRecordButtonPressed() {
    if (controller != null &&
        controller.value.isInitialized &&
        !controller.value.isRecordingVideo) {
      print("*Start Record");
      countdownTime();
      startVideoRecording();
    } else if (controller != null &&
        controller.value.isInitialized &&
        controller.value.isRecordingVideo) {
      print("*Stop Record");
      timer.cancel();
      stopAndReturnVideo();
    }
  }

  void stopAndReturnVideo() async {
    XFile xFileVideo = await stopVideoRecording();
    returnToRegisterPage(xFileVideo.path);
  }

  // void onStopButtonPressed() {
  //   stopVideoRecording().then((_) {
  //     if (mounted) setState(() {});
  //     showInSnackBar('Video recorded to: $videoPath');
  //   });
  // }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  void onReturnButtonPressed() {
    Navigator.pop(context, videoPath);
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<XFile> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      var file = await controller.stopVideoRecording();
      // await _startVideoPlayer(file);
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer(XFile file) async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(file.path));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      var file = await controller.takePicture();
      return file.path;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
