import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:register_demo/models/livenessCompareResponse.dart';
import 'package:video_compress/video_compress.dart';

class LivenessStorage {
  static LivenessStorage _instance;
  static LivenessStorage getInstance() {
    log("Out Instace---------------------------------------------");
    if (_instance == null) {
      log("Instace---------------------------------------------");
      _instance = LivenessStorage();
    ErrorResponse error = new ErrorResponse(code: "",message: "");
    Response response = new Response(result:"",description:"",sim: "0",bestFrameBase64:"",requestId:"",error: error);
    _instance.livenessCompareResponse = new LivenessCompareResponse(response: response);
    }
    return _instance;
  }

  PickedFile imageFile;
  File videoFile;
  LivenessCompareResponse livenessCompareResponse;

  setImageFile(image) {
    imageFile = image;
  }

  setVideoFile(video) {
    videoFile = video;
  }

  Future<String> convertToBase64(File file) async {
    Uint8List bytes = await file.readAsBytes();
    print(file.lengthSync());
    List<int> fileBytes = file.readAsBytesSync();
    // print(fileBytes);
    String base64file = base64Encode(fileBytes);
    // log(base64file);
    return base64file;
  }

  Future<File> compressVideo(File video) async {
    print("Input Video Size: "+video.lengthSync().toString());
    await VideoCompress.setLogLevel(2);
    final MediaInfo compressedVideo = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: false,
    );
    print("Output Video Size: "+((compressedVideo.filesize).toString()));
    
    return compressedVideo.file;
  }

  setLivenessCompareResponse(response) {
    livenessCompareResponse =
        LivenessCompareResponse.fromJson(json.decode(response));
  }
}
