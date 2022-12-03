import 'dart:async';

import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class SpendingDetailRepository {
  FutureOr<List<UserModel>> getParticipantsOfSpending(
      SpendingModel spending) async {
    final participantsRefs = await Future.wait(
        spending.participants.map((participant) => participant.get()).toList());
    final participants =
        participantsRefs.map((doc) => UserModel.fromMap(doc.data()!)).toList();
    return participants;
  }
}
