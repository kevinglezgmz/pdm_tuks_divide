import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';

class UserActivityRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  final spendingsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.spendings);
  final paymentsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.payments);

  FutureOr<Map<String, List<dynamic>>> getUserActivity() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return {};
    }
    final userRef = usersCollection.doc(uid);
    final payedData =
        await paymentsCollection.where('payer', isEqualTo: userRef).get();
    final payedRefs =
        payedData.docs.map((doc) => PaymentModel.fromMap(doc.data())).toList();

    final debtData =
        await paymentsCollection.where('receiver', isEqualTo: userRef).get();
    final debtRefs =
        debtData.docs.map((doc) => PaymentModel.fromMap(doc.data())).toList();

    final spentData =
        await spendingsCollection.where('paidBy', isEqualTo: userRef).get();
    final spentRefs =
        spentData.docs.map((doc) => SpendingModel.fromMap(doc.data())).toList();

    payedRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    debtRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    spentRefs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return {
      "paymentRefs": payedRefs,
      "debtRefs": debtRefs,
      "spentRefs": spentRefs
    };
  }
}
