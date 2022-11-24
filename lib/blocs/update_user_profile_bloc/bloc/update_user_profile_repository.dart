import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/user_model.dart';

class UpdateUserProfileRepository {
  FutureOr<UserModel> updateUserProfile(String uid, String firstName,
      String lastName, String imageUrl, String displayName) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(uid)
        .update({
      "displayName": displayName,
      "firstName": firstName,
      "lastName": lastName,
      "pictureUrl": imageUrl
    });
    final updatedUserProfileDocument = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(uid)
        .get();
    final updatedUserProfile =
        _convertMapToUser(updatedUserProfileDocument.data()!);
    if (updatedUserProfile.displayName != displayName ||
        updatedUserProfile.firstName != firstName ||
        updatedUserProfile.lastName != lastName ||
        updatedUserProfile.pictureUrl != imageUrl) {
      log("nope, valió");
      throw "User not updated";
    }
    return updatedUserProfile;
  }

  UserModel _convertMapToUser(Map<String, dynamic> userMap) {
    return UserModel(
        displayName: userMap["displayName"],
        email: userMap["email"]!,
        firstName: userMap["firstName"],
        lastName: userMap["lastName"],
        pictureUrl: userMap["pictureUrl"],
        uid: userMap["uid"]!);
  }
}
