import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PreviewPicturePage extends StatefulWidget {
  final Widget pictureWidget;
  final String resultsText;
  final PickedFile pickedImage;
  const PreviewPicturePage(
      {Key key, this.pictureWidget, this.pickedImage, this.resultsText})
      : super(key: key);

  @override
  _PreviewPicturePageState createState() => _PreviewPicturePageState();
}

class _PreviewPicturePageState extends State<PreviewPicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 12,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      // colors: [Color(0xff6bceff), Color(0xff6bceff)],
                      // colors: [Color(0xff6bceff), Colors.lightBlue[400]],
                      colors: [Colors.red[800], Colors.red[400]]),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 36),
                      child: Text(
                        'Preview',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Image.file(File(
                widget.pickedImage.path,
              )),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Readable text",
                    style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),

            Container(
                padding: EdgeInsets.all(20),
                child: RichText(
                    text: TextSpan(
                        text: widget.resultsText,
                        style: TextStyle(color: Colors.black)))),
            // ------------------ Field -------------------------
            Container(
              alignment: Alignment.bottomCenter,
              // height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // Color(0xff6bceff),
                              // Color(0xFF00abff),
                              Colors.red[300],
                              Colors.red[500],
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          // 'Sign Up'.toUpperCase(),
                          'Back',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
