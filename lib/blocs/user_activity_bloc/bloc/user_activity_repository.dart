import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/groups_users_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_activity_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class UserActivityRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  final spendingsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.spendings);
  final paymentsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.payments);
  final groupsSpendingsCollection = FirebaseFirestore.instance
      .collection(FirebaseCollections.groupsSpendings);
  final groupsUsersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groupsUsers);
  final groupsRepository = GroupsRepository();

  FutureOr<List<UserModel>> _getUsersData(
      List<GroupsUsersModel> groups, UserModel user) async {
    List<UserModel> users = [];
    final groupsRefs =
        await Future.wait(groups.map((group) => group.group.get()).toList());
    final groupsRefsToModel = groupsRefs
        .map((doc) =>
            GroupModel.fromMap(doc.data()!..addAll({"groupId": doc.id})))
        .toList();

    for (int i = 0; i < groupsRefsToModel.length; i++) {
      final members =
          await GroupsRepository.getMembersOfGroup(groupsRefsToModel[i]);
      users.addAll(members);
    }
    users = users.toSet().toList();
    users.remove(user);

    return users;
  }

  FutureOr<List<GroupSpendingModel>> _getOwingsData(
      List<SpendingModel> spendingsDoneByMe, UserModel user) async {
    List<GroupSpendingModel> owings = [];

    final spendingsOwingListsRefs = await Future.wait(spendingsDoneByMe.map(
        (spending) => groupsSpendingsCollection
            .where('spending',
                isEqualTo: spendingsCollection.doc(spending.spendingId))
            .get()));

    for (int i = 0; i < spendingsOwingListsRefs.length; i++) {
      final spendingOwings = spendingsOwingListsRefs[i]
          .docs
          .map((doc) => GroupSpendingModel.fromMap(doc.data()));
      owings.addAll(spendingOwings);
    }

    //owings.removeWhere((owing) => owing.user.id == user.uid);
    return owings;
  }

  FutureOr<UserActivityModel?> getUserActivity() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final userRef = usersCollection.doc(uid);
    final userDoc = await userRef.get();
    final user = UserModel.fromMap(userDoc.data()!);

    final myPaymentsRefs =
        await paymentsCollection.where('payer', isEqualTo: userRef).get();
    final myPayments = myPaymentsRefs.docs
        .map((doc) =>
            PaymentModel.fromMap(doc.data()..addAll({"paymentId": doc.id})))
        .toList();

    final paybackRefs =
        await paymentsCollection.where('receiver', isEqualTo: userRef).get();
    final payback = paybackRefs.docs
        .map((doc) =>
            PaymentModel.fromMap(doc.data()..addAll({"paymentId": doc.id})))
        .toList();

    final spendingDoneByMeRefs =
        await spendingsCollection.where('paidBy', isEqualTo: userRef).get();
    final spendingDoneByMe = spendingDoneByMeRefs.docs
        .map((doc) =>
            SpendingModel.fromMap(doc.data()..addAll({'spendingId': doc.id})))
        .toList();

    final myDebtsRefs =
        await groupsSpendingsCollection.where('user', isEqualTo: userRef).get();
    final myDebts = myDebtsRefs.docs
        .map((doc) => GroupSpendingModel.fromMap(doc.data()))
        .toList();

    final groupsUsersRefs =
        await groupsUsersCollection.where('user', isEqualTo: userRef).get();
    final groupsUsers = groupsUsersRefs.docs
        .map((doc) => GroupsUsersModel.fromMap(doc.data()))
        .toList();

    final otherUsersData = await _getUsersData(groupsUsers, user);
    final owings = await _getOwingsData(spendingDoneByMe, user);

    myPayments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    payback.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    spendingDoneByMe.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return UserActivityModel(
        myPayments: myPayments,
        payback: payback,
        spendingDoneByMe: spendingDoneByMe,
        otherUsers: otherUsersData,
        myDebts: myDebts,
        owings: owings);
  }
}
