import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class PaymentsRepository {
  static final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  static final groupsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groups);
  static final groupsUsersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groupsUsers);
  static final groupsSpendingsCollection = FirebaseFirestore.instance
      .collection(FirebaseCollections.groupsSpendings);
  static final spendingsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.spendings);
  static final paymentsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.payments);

  Future<PaymentModel?> addPaymentDetail(
    double amount,
    String description,
    UserModel payer,
    UserModel receiver,
    String? paymentPic,
    GroupModel group,
  ) async {
    final Map<String, dynamic> dataToSend = {
      "amount": amount,
      "createdAt": Timestamp.now(),
      "description": description,
      "group": groupsCollection.doc(group.groupId),
      "payer": usersCollection.doc(payer.uid),
      "receiver": usersCollection.doc(receiver.uid),
      "paymentPic": paymentPic,
    };
    final paymentRef = await paymentsCollection.add(dataToSend);
    return PaymentModel.fromMap(
        dataToSend..addAll({"paymentId": paymentRef.id}));
  }
}
