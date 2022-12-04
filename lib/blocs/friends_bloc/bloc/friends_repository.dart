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

  static StreamSubscription<FriendsStreamResult> getUserFriendsSubscription(
    Function(FriendsStreamResult) callback,
    UserModel me,
  ) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw "No user id";
    }
    final userRef = usersCollection.doc(me.uid);
    return FriendsStream(
      userRef: userRef,
      me: me,
      usersCollection: usersCollection,
      friendsCollection: friendsCollection,
    ).listen((event) {
      callback(event);
    });
  }
}

class FriendsStreamResult {
  final List<UserModel> friends;
  final UserModel? newFriend;

  FriendsStreamResult({
    required this.friends,
    required this.newFriend,
  });
}

class FriendsStream extends Stream {
  DocumentReference<Map<String, dynamic>> userRef;
  CollectionReference<Map<String, dynamic>> usersCollection;
  CollectionReference<Map<String, dynamic>> friendsCollection;
  final UserModel me;

  List<UserModel> friendsA = [];
  List<UserModel> friendsB = [];

  FriendsStream({
    required this.userRef,
    required this.usersCollection,
    required this.friendsCollection,
    required this.me,
  });

  @override
  StreamSubscription<FriendsStreamResult> listen(
    void Function(FriendsStreamResult event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _createFriendsStream().listen(onData);
  }

  Stream<FriendsStreamResult> _createFriendsStream() {
    final StreamController<FriendsStreamResult> controller = StreamController();
    List<FriendModel> friendModelsA = [];
    List<FriendModel> friendModelsB = [];
    friendsCollection.where('userA', isEqualTo: userRef).snapshots().listen(
      (userFriendRefsA) async {
        friendModelsA = userFriendRefsA.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();
        final totalFriends = [...friendModelsA, ...friendModelsB];
        totalFriends.sort((friendA, friendB) =>
            friendA.friendedAt.compareTo(friendB.friendedAt));
        final usersDataFutures = totalFriends.map((friendDoc) {
          if (friendDoc.userA == userRef) {
            return friendDoc.userB.get();
          } else {
            return friendDoc.userA.get();
          }
        }).toList();
        final friendsData = await Future.wait(usersDataFutures);
        final friends =
            friendsData.map((doc) => UserModel.fromMap(doc.data()!)).toList();
        controller.sink.add(FriendsStreamResult(
          friends: friends,
          newFriend: null,
        ));
      },
    );
    bool isFirstRun = true;
    friendsCollection.where('userB', isEqualTo: userRef).snapshots().listen(
      (userFriendRefsB) async {
        friendModelsB = userFriendRefsB.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();

        final totalFriends = [...friendModelsA, ...friendModelsB];
        totalFriends.sort((friendA, friendB) =>
            friendA.friendedAt.compareTo(friendB.friendedAt));
        final usersDataFutures = totalFriends.map((friendDoc) {
          if (friendDoc.userA == userRef) {
            return friendDoc.userB.get();
          } else {
            return friendDoc.userA.get();
          }
        }).toList();
        final friendsData = await Future.wait(usersDataFutures);
        final friends =
            friendsData.map((doc) => UserModel.fromMap(doc.data()!)).toList();
        if (isFirstRun) {
          isFirstRun = false;
          controller.sink
              .add(FriendsStreamResult(friends: friends, newFriend: null));
        } else {
          controller.sink.add(
              FriendsStreamResult(friends: friends, newFriend: friends.last));
        }
      },
    );

    return controller.stream;
  }
}
