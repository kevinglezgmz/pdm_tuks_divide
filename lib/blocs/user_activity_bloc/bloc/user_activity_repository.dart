import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
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

  Future<List<UserModel>> _getUsersData(
    List<PaymentModel> spendingRefs,
    List<SpendingModel> spentRefs,
    List<PaymentModel> debtRefs,
  ) async {
    List<UserModel> users = [];
    for (var paymentRef in spendingRefs) {
      final payment = await paymentRef.receiver.get();
      final foundUser = users
          .where((UserModel user) =>
              user.uid == UserModel.fromMap(payment.data()!).uid)
          .toList();
      if (foundUser.isNotEmpty) {
        users.add(foundUser[0]);
      }
    }

    for (var debtRef in debtRefs) {
      final debt = await debtRef.payer.get();
      final foundUser = users
          .where((UserModel user) =>
              user.uid == UserModel.fromMap(debt.data()!).uid)
          .toList();
      if (foundUser.isNotEmpty) {
        users.add(foundUser[0]);
      }
    }

    for (var spentRef in spentRefs) {
      final participantsRef = spentRef.participants;
      for (var participantRef in participantsRef) {
        final participant = await participantRef.get();
        final foundUser = users
            .where((UserModel user) =>
                user.uid == UserModel.fromMap(participant.data()!).uid)
            .toList();
        if (foundUser.isNotEmpty) {
          users.add(foundUser[0]);
        }
      }
    }
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

    final otherUsersData =
        await _getUsersData(spendingRefs, spentRefs, debtRefs);

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
