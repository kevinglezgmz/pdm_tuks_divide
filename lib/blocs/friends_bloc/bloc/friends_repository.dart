import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/friend_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class FriendsRepository {
  static final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  static final friendsCollection =
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
      throw 'No se econtró ningún usuario con el correo $email';
    }
    final foundUser = usersQuery.docs[0];
    final userRef = usersCollection.doc(uid);
    final userFriendRef = foundUser.reference;
    FriendModel(
        friendedAt: Timestamp.now(), userA: userRef, userB: userFriendRef);
    Map<String, dynamic> friendDataToUpload = {
      'userA': userRef,
      'userB': userFriendRef,
      'friendedAt': Timestamp.now(),
    };
    await friendsCollection.add(friendDataToUpload);
    return UserModel.fromMap(usersQuery.docs[0].data());
  }

  static StreamSubscription<List<UserModel>> getUserFriendsSubscription(
      Function(List<UserModel>) callback) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw "No user id";
    }
    final userRef = usersCollection.doc(uid);
    return FriendsStream(
      userRef: userRef,
      usersCollection: usersCollection,
      friendsCollection: friendsCollection,
    ).listen((event) {
      callback(event);
    });
  }
}

class FriendsStream extends Stream {
  DocumentReference<Map<String, dynamic>> userRef;
  CollectionReference<Map<String, dynamic>> usersCollection;
  CollectionReference<Map<String, dynamic>> friendsCollection;

  List<UserModel> friendsA = [];
  List<UserModel> friendsB = [];

  FriendsStream({
    required this.userRef,
    required this.usersCollection,
    required this.friendsCollection,
  });

  @override
  StreamSubscription<List<UserModel>> listen(
    void Function(List<UserModel> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _createFriendsStream().listen(onData);
  }

  Stream<List<UserModel>> _createFriendsStream() {
    final StreamController<List<UserModel>> controller = StreamController();
    friendsCollection.where('userA', isEqualTo: userRef).snapshots().listen(
      (userFriendRefsA) async {
        final userFriendsA = userFriendRefsA.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();

        final usersDataFutures =
            userFriendsA.map((friendDoc) => friendDoc.userB.get()).toList();
        final friendsData = await Future.wait(usersDataFutures);
        friendsA =
            friendsData.map((doc) => UserModel.fromMap(doc.data()!)).toList();
        controller.sink.add([...friendsA, ...friendsB]);
      },
    );
    friendsCollection.where('userB', isEqualTo: userRef).snapshots().listen(
      (userFriendRefsB) async {
        final userFriendsB = userFriendRefsB.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();

        final usersDataFutures =
            userFriendsB.map((friendDoc) => friendDoc.userA.get()).toList();
        final friendsData = await Future.wait(usersDataFutures);
        friendsB =
            friendsData.map((doc) => UserModel.fromMap(doc.data()!)).toList();
        controller.sink.add([...friendsA, ...friendsB]);
      },
    );

    return controller.stream;
  }
}
