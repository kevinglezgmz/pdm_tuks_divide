import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageRepository {
  File? _img;

  Future _uploadPicture(String collection) async {
    var stamp = DateTime.now();
    if (_img == null) return "";

    final TaskSnapshot task = await FirebaseStorage.instance
        .ref("$collection/img_$stamp.png")
        .putFile(_img!);

    String imgUrl =
        await task.storage.ref("$collection/img_$stamp.png").getDownloadURL();
    return imgUrl;
  }

  FutureOr<String> pickImage(String collection, String typeOfUpload) async {
    final pickedFile = await ImagePicker().pickImage(
      source:
          typeOfUpload == "camera" ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 720,
      imageQuality: 65,
    );
    if (pickedFile != null) {
      _img = File(pickedFile.path);
      return await _uploadPicture(collection);
    } else {
      throw "Could not get selected image";
    }
  }
}
