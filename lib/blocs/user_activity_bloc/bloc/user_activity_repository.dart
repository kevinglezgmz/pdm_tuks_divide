import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/groups_users_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_activity_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class UserActivityRepository {
  static final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  static final spendingsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.spendings);
  static final paymentsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.payments);
  static final groupsSpendingsCollection = FirebaseFirestore.instance
      .collection(FirebaseCollections.groupsSpendings);
  static final groupsUsersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groupsUsers);
  static final groupsRepository = GroupsRepository();

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

  static StreamSubscription<NullableUserActivityUseState>
      getUserActivitySubscription(
    UserModel me,
    Function(NullableUserActivityUseState) callback,
  ) {
    return UserActivityStream(me: me).listen(callback);
  }
}

class UserActivityStream extends Stream<NullableUserActivityUseState> {
  NullableUserActivityUseState activityUseState =
      const NullableUserActivityUseState();
  Map<String, UserModel> userIdToUserMap = {};
  final UserModel me;
  UserActivityStream({required this.me});

  @override
  StreamSubscription<NullableUserActivityUseState> listen(
    void Function(NullableUserActivityUseState event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _createUserActivityStream().listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  Stream<NullableUserActivityUseState> _createUserActivityStream() {
    final StreamController<NullableUserActivityUseState> controller =
        StreamController();
    userIdToUserMap[me.uid] = me;

    // Get spendings where I participate
    bool isFirstSpendingsRun = true;
    UserActivityRepository.spendingsCollection
        .where('participants',
            arrayContains: UserActivityRepository.usersCollection.doc(me.uid))
        .snapshots()
        .listen((event) async {
      List<SpendingModel> spendingsWhereIParticipate = event.docs
          .map((doc) =>
              SpendingModel.fromMap(doc.data()..addAll({"spendingId": doc.id})))
          .toList();
      spendingsWhereIParticipate.sort((spendingA, spendingB) =>
          spendingA.createdAt.compareTo(spendingB.createdAt));
      if (isFirstSpendingsRun == false &&
          spendingsWhereIParticipate.isNotEmpty &&
          spendingsWhereIParticipate.last.addedBy.id != me.uid) {
        activityUseState = activityUseState.copyWith(
          newSpendingIParticipatedIn: spendingsWhereIParticipate.last,
        );
      }
      isFirstSpendingsRun = false;
      if (event.docs.isEmpty) {
        activityUseState = activityUseState.copyWith(
          spendingsDetails: [],
          spendingsWhereIDidNotPay: [],
          spendingsWhereIPaid: [],
          isLoadingSpendings: false,
          newSpendingIParticipatedIn: null,
        );
        controller.sink.add(activityUseState);

        return;
      }
      List<GroupSpendingModel> spendingsDetails = await Future.wait(
        spendingsWhereIParticipate.map(
          (spending) async {
            QuerySnapshot<Map<String, dynamic>> data =
                await UserActivityRepository.groupsSpendingsCollection
                    .where("spending",
                        isEqualTo: UserActivityRepository.spendingsCollection
                            .doc(spending.spendingId))
                    .get();

            data = await UserActivityRepository.groupsSpendingsCollection
                .where("spending",
                    isEqualTo: UserActivityRepository.spendingsCollection
                        .doc(spending.spendingId))
                .get();

            return data.docs
                .map((doc) => GroupSpendingModel.fromMap(doc.data()))
                .toList();
          },
        ),
      ).then((value) =>
          value.reduce((value, spendings) => [...value, ...spendings]));

      List<SpendingModel> spendingsWhereIPaid = [];
      List<SpendingModel> spendingsWhereIDidNotPay = [];
      for (final SpendingModel spending in spendingsWhereIParticipate) {
        if (spending.paidBy ==
            UserActivityRepository.usersCollection.doc(me.uid)) {
          spendingsWhereIPaid.add(spending);
        } else {
          spendingsWhereIDidNotPay.add(spending);
        }
      }

      await Future.wait(spendingsWhereIDidNotPay.map((spending) async {
        final userData = await spending.paidBy.get();
        if (userData.exists) {
          userIdToUserMap[spending.paidBy.id] =
              UserModel.fromMap(userData.data()!);
        }
      }));

      activityUseState = activityUseState.copyWith(
        spendingsDetails: spendingsDetails,
        spendingsWhereIDidNotPay: spendingsWhereIDidNotPay,
        spendingsWhereIPaid: spendingsWhereIPaid,
        isLoadingSpendings: false,
        userIdToUserMap: userIdToUserMap,
      );
      controller.sink.add(activityUseState);
      activityUseState = activityUseState.copyWith(
        newSpendingIParticipatedIn: null,
      );
    });

    // Get payments made by me
    UserActivityRepository.paymentsCollection
        .where('payer',
            isEqualTo: UserActivityRepository.usersCollection.doc(me.uid))
        .snapshots()
        .listen((event) async {
      final List<PaymentModel> paymentsMadeByMe = event.docs
          .map((doc) =>
              PaymentModel.fromMap(doc.data()..addAll({"paymentId": doc.id})))
          .toList();

      await Future.wait(paymentsMadeByMe.map((payment) async {
        final userData = await payment.receiver.get();
        if (userData.exists) {
          userIdToUserMap[payment.receiver.id] =
              UserModel.fromMap(userData.data()!);
        }
      }));

      activityUseState = activityUseState.copyWith(
        paymentsMadeByMe: paymentsMadeByMe,
        isLoadingPaymentsByMe: false,
        userIdToUserMap: userIdToUserMap,
      );
      controller.sink.add(activityUseState);
    });

    // Get payments made to me
    bool isFirstPaymentsRun = true;
    UserActivityRepository.paymentsCollection
        .where('receiver',
            isEqualTo: UserActivityRepository.usersCollection.doc(me.uid))
        .snapshots()
        .listen((event) async {
      final List<PaymentModel> paymentsMadeToMe = event.docs
          .map((doc) =>
              PaymentModel.fromMap(doc.data()..addAll({"paymentId": doc.id})))
          .toList();

      await Future.wait(
        paymentsMadeToMe.map((payment) async {
          final userData = await payment.payer.get();
          if (userData.exists) {
            userIdToUserMap[payment.payer.id] =
                UserModel.fromMap(userData.data()!);
          }
        }).toList(),
      );
      paymentsMadeToMe.sort(
        (paymentA, paymentB) =>
            paymentA.createdAt.compareTo(paymentB.createdAt),
      );
      if (isFirstPaymentsRun == false && paymentsMadeToMe.isNotEmpty) {
        activityUseState = activityUseState.copyWith(
          newPaymentMadeToMe: paymentsMadeToMe.last,
        );
      }
      isFirstPaymentsRun = false;

      activityUseState = activityUseState.copyWith(
        paymentsMadeToMe: paymentsMadeToMe,
        isLoadingPaymentsToMe: false,
        userIdToUserMap: userIdToUserMap,
      );
      controller.sink.add(activityUseState);
      activityUseState = activityUseState.copyWith(
        newPaymentMadeToMe: null,
      );
    });

    return controller.stream;
  }
}
