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
    final groupsRefsToModel =
        groupsRefs.map((doc) => GroupModel.fromMap(doc.data()!)).toList();

    for (int i = 0; i < groupsRefsToModel.length; i++) {
      final members =
          await groupsRepository.getMembersOfGroup(groupsRefsToModel[i]);
      users.addAll(members);
    }

    /*final membersList = await Future.wait(groupsRefsToModel
        .map((group) => groupsRepository.getMembersOfGroup(group)));*/

    /*for (int i = 0; i < membersList.length; i++) {
      users.addAll(membersList[0]);
    }*/

    users = users.toSet().toList();
    users.remove(user);

    //final usersGroupRefs = await Future.wait(groupsRefsToModel.map((group) => grou))

    return users;
  }

  List<GroupSpendingModel> _getOwingsFromGroups(
      List<GroupSpendingModel> owingRefs, List<SpendingModel> spentRefs) {
    List<GroupSpendingModel> owings = [];

    for (var owing in owingRefs) {
      for (var spending in spentRefs) {
        final owingsFound =
            spending.participants.where((s) => s.id == owing.user.id).toList();
        if (owingsFound.isNotEmpty) {
          owings.add(owing);
        }
      }
    }

    return owings;
  }

  List<GroupSpendingModel> _getMyDebt(
      List<GroupSpendingModel> spendingRefs, List<SpendingModel> spentRefs) {
    List<GroupSpendingModel> debts = [];

    for (var spent in spentRefs) {
      for (var spending in spendingRefs) {
        final found = spent.paidBy.id != spending.user.id;
        if (found) {
          debts.add(spending);
        }
      }
    }

    return debts;
  }

  FutureOr<UserActivityModel?> getUserActivity() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final userRef = usersCollection.doc(uid);
    final userDoc = await userRef.get();
    final user = UserModel.fromMap(userDoc.data()!);
    final spendigData =
        await paymentsCollection.where('payer', isEqualTo: userRef).get();
    final spendingRefs = spendigData.docs
        .map((doc) => PaymentModel.fromMap(doc.data()))
        .toList();

    final debtData =
        await paymentsCollection.where('receiver', isEqualTo: userRef).get();
    final debtRefs =
        debtData.docs.map((doc) => PaymentModel.fromMap(doc.data())).toList();

    final spentData =
        await spendingsCollection.where('paidBy', isEqualTo: userRef).get();
    final spentRefs = spentData.docs
        .map((doc) =>
            SpendingModel.fromMap(doc.data()..addAll({'spendingId': doc.id})))
        .toList();

    final spendingsData =
        await groupsSpendingsCollection.where('user', isEqualTo: userRef).get();
    final spendingsRefs = spendingsData.docs
        .map((doc) => GroupSpendingModel.fromMap(doc.data()))
        .toList();

    final owingData = await groupsSpendingsCollection
        .where('user', isNotEqualTo: userRef)
        .get();
    final owingRefs = owingData.docs
        .map((doc) => GroupSpendingModel.fromMap(doc.data()))
        .toList();

    final owingRefsKnown = _getOwingsFromGroups(owingRefs, spentRefs);
    final myDebtRefs = _getMyDebt(spendingsRefs, spentRefs);

    final groupsUsersRefs =
        await groupsUsersCollection.where('user', isEqualTo: userRef).get();
    final groupsUsers = groupsUsersRefs.docs
        .map((doc) => GroupsUsersModel.fromMap(doc.data()))
        .toList();

    final otherUsersData = await _getUsersData(groupsUsers, user);

    spendingRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    debtRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    spentRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return UserActivityModel(
        spendingRefs: spendingRefs,
        debtRefs: debtRefs,
        spentRefs: spentRefs,
        otherUsers: otherUsersData,
        notDebt: spendingsRefs,
        owingRefs: owingRefsKnown,
        myDebtRefs: myDebtRefs);
  }
}
