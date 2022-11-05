import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageRepository {
  File? _img;

  Future _uploadPicture(String collection) async {
    try {
      var stamp = DateTime.now();
      if (_img == null) return "";

      UploadTask task = FirebaseStorage.instance
          .ref("$collection/img_$stamp.png")
          .putFile(_img!);

      await task;
      String imgUrl =
          await task.storage.ref("$collection/img_$stamp.png").getDownloadURL();
      return imgUrl;
    } catch (error) {
      rethrow;
    }
  }

  FutureOr<String> pickImage(String collection, String typeOfUpload) async {
    try {
      log("${typeOfUpload == "camera"}");
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
    } catch (error) {
      rethrow;
    }
  }
}
