import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';
import 'package:register_demo/services/registerStorage.dart';
// import 'package:image_editor/image_editor.dart';


class PreviewPhoto extends StatefulWidget {
  final String path;
  const PreviewPhoto({Key key, this.path}) : super(key: key);

  @override
  _PreviewPhotoState createState() {
    return _PreviewPhotoState();
  }
}

class _PreviewPhotoState extends State<PreviewPhoto> {
  /// Display the preview from the camera (or a message if the preview is not available).
  // String path;
  File imageFile;
  File _imageFile;

  RegisterStorage registerStorage;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.path);
    registerStorage = RegisterStorage.getInstance();
    flipImage();
  }

  Future<void> flipImage() async {
    // print("---FlipImage");
    // final img.Image capturedImage =
    //     img.decodeImage(await File(widget.file).readAsBytes());
    // final img.Image orientedImage = img.bakeOrientation(capturedImage);
    // await File(widget.file).writeAsBytes(img.encodeJpg(orientedImage));
    // final ExtendedImageEditorState state = editorKey.currentState;
    // final Rect rect = state.getCropRect();
    // final ImageEditorOption option = ImageEditorOption();
    // option.addOption(ClipOption.fromRect(rect));
    // image = image.FlipOption(horizontal:true, vertical:false);
    // image = await FlutterExifRotation.rotateImage(path: widget.file);
    // File file = File(path);
    print("flip");
    // imageFile = await FlutterExifRotation.rotateImage(path: widget.path);
    // imageFile = null;
    final img.Image capturedImage = img.decodeImage(await File(widget.path).readAsBytes());
  final img.Image orientedImage = img.bakeOrientation(capturedImage);
  await File(widget.path).writeAsBytes(img.encodeJpg(orientedImage));


    // final editorOption = ImageEditorOption();
    // editorOption.addOption(RotateOption(180));
    // final dst = await loadFromAsset(File(widget.path));
    
    // final result = await ImageEditor.editImage(image: dst, imageEditorOption: editorOption);
    imageFile = File(widget.path);
    setState(() {
      _imageFile = imageFile;
      // _imageFile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            iconSize: 40,
            onPressed: () =>
                // Navigator.of(context).pop(),
                Navigator.popUntil(context, ModalRoute.withName('/register'))),
        backgroundColor: Colors.black,
      ),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: AutoSizeText(
                  'โปรดตรวจสอบรูปสามารถมองเห็นได้ชัดเจน',
                  style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  maxLines: 1,
                ),
                    )),
              ),
            ),

            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: photoWidget(),
                  ),
                ),
                // decoration: BoxDecoration(
                //   color: Colors.black,
                // ),
              ),
            ),

            //  bottomActionWidget(),
            Expanded(
                child: Container(
              //  height: 400,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // _captureControlRowWidget(),
                    _tryAgainButtonWidget(),
                    Spacer(),
                    _confirmButtonWidget(),
                    // _cameraTogglesRowWidget(),
                    // _thumbnailWidget(),
                  ],
                ),
              ),
            ))
          ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: flipImage,
      //   // tooltip: 'Toggle',
      // )
    );
  }

  Widget photoWidget() {
    return Center(
      child: new Image.file(_imageFile),
    );
  }

  Widget _tryAgainButtonWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: RawMaterialButton(
                  onPressed: () {
                    onRetryButtonPressed();
                  },
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.refresh_rounded,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
            // Container(
            //   padding: EdgeInsets.all(40),
            //   child: IconButton(
            //       icon: const Icon(Icons.refresh_rounded),
            //       iconSize: MediaQuery.of(context).size.width * 0.15,
            //       color: Colors.white,
            //       onPressed: onConfirmButtonPressed),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _confirmButtonWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: RawMaterialButton(
                  onPressed: () {
                    onConfirmButtonPressed();
                  },
                  fillColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
          ],
        ),
      ),
    );
  }

  void onRetryButtonPressed() {
    Navigator.pop(context);
  }

  void onConfirmButtonPressed() {
    registerStorage.setImageFile(_imageFile);
    Navigator.popUntil(context, ModalRoute.withName('/register'));
  }
}
