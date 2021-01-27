import 'dart:developer';
import 'dart:io';
import 'package:register_demo/models/person.dart';

class RegisterStorage {
  static RegisterStorage _instance;
  static RegisterStorage getInstance() {
    if (_instance == null) {
      _instance = RegisterStorage();
    }
    return _instance;
  }

  File imageFile;
  File videoFile;
  String videoPath;
  Person person;


  setImageFile(File image) {
    imageFile = image;
  }

  setVideoFile(File video) {
    videoFile = video;
  }

  setVideoPath(String path) {
    videoPath = path;
  }

  clearData() {
    imageFile = null;
    videoFile = null;
    videoPath = null;
  }

  initialPerson(){
    if(person == null){
      log("initialPerson");
      createPerson();
    }
  }

  void createPerson() {
    log("-----------Create New Person------------");
    person = new Person(
        nameTitleTh: '',
        firstnameTh: '',
        lastnameTh: '',
        firstnameEng: '',
        lastnameEng: '',
        idno: '',
        dateOfBirth: '',
        username: '',
        email: '');
  }

  setPerson(Person person) {
    this.person = person;
  }

  clearPerson() {
    person = null;
  }
}

// PickedFile imageFile;
// File videoFile;
// LivenessCompareResponse livenessCompareResponse;

// setImageFile(image) {
//   imageFile = image;
// }

// setVideoFile(video) {
//   videoFile = video;
// }

// Future<String> convertToBase64(File file) async {
//   Uint8List bytes = await file.readAsBytes();
//   print(file.lengthSync());
//   List<int> fileBytes = file.readAsBytesSync();
//   // print(fileBytes);
//   String base64file = base64Encode(fileBytes);
//   // log(base64file);
//   return base64file;
// }

// Future<File> compressVideo(File video) async {
//   print("Input Video Size: "+video.lengthSync().toString());
//   await VideoCompress.setLogLevel(2);
//   final MediaInfo compressedVideo = await VideoCompress.compressVideo(
//     video.path,
//     quality: VideoQuality.LowQuality,
//     deleteOrigin: false,
//     includeAudio: false,
//   );
//   print("Output Video Size: "+((compressedVideo.filesize).toString()));

//   return compressedVideo.file;
// }

// setLivenessCompareResponse(response) {
//   livenessCompareResponse =
//       LivenessCompareResponse.fromJson(json.decode(response));
// }
// }
