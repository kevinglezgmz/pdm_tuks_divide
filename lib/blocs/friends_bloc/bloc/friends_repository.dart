import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/friend_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class FriendsRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  final friendsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.friends);

  Future<List<UserModel>> getUserFriends() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return [];
    }
    final userRef = usersCollection.doc(uid);
    final userFriendRefsA =
        await friendsCollection.where('userA', isEqualTo: userRef).get();
    final userFriendRefsB =
        await friendsCollection.where('userB', isEqualTo: userRef).get();

    final userFriendsA = userFriendRefsA.docs
        .map((doc) => FriendModel.fromMap(doc.data()))
        .toList();
    final userFriendsB = userFriendRefsB.docs
        .map((doc) => FriendModel.fromMap(doc.data()))
        .toList();
    final usersDataFutures = userFriendsA
        .map((friendDoc) => friendDoc.userB.get())
        .toList()
      ..addAll(userFriendsB.map((friendDoc) => friendDoc.userA.get()).toList());

    final friendsData = await Future.wait(usersDataFutures);
    return friendsData.map((doc) => UserModel.fromMap(doc.data()!)).toList();
  }

  Future<UserModel?> addFriendByMail(String email) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final usersQuery =
        await usersCollection.where('email', isEqualTo: email).get();
    if (usersQuery.docs.isEmpty) {
      throw 'No user found for the email $email';
    }
    final foundUser = usersQuery.docs[0];
    final userRef = usersCollection.doc(uid);
    final userFriendRef = foundUser.reference;
    FriendModel(
        friendedAt: Timestamp.now(), userA: userRef, userB: userFriendRef);
    Map<String, dynamic> friendDataToUpload = {
      'userA': userRef,
      'user': userFriendRef,
      'friendedAt': Timestamp.now(),
    };
    await friendsCollection.add(friendDataToUpload);
    return UserModel.fromMap(usersQuery.docs[0].data());
  }
}
