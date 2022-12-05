import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class ParticipantItemInGroup extends StatelessWidget {
  final UserModel userData;
  final VoidCallback onTap;
  const ParticipantItemInGroup(
      {super.key, required this.userData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(userData.displayName ?? userData.fullName ?? "<No Name>"),
          subtitle: BlocBuilder<UserActivityBloc, UserActivityUseState>(
            builder: (context, state) {
              return _getFriendTextInParticularGroup(userData, state, context);
            },
          ),
          leading: CircleAvatar(
              backgroundImage: userData.pictureUrl == null ||
                      userData.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                  : NetworkImage(userData.pictureUrl!)),
        ),
      ),
    );
  }

  Widget _getFriendTextInParticularGroup(
    UserModel friend,
    UserActivityUseState state,
    BuildContext context,
  ) {
    UserModel? me = BlocProvider.of<MeBloc>(context).state.me!;
    if (friend == me) {
      return const Text("Tú");
    }
    GroupModel? currentGroup =
        BlocProvider.of<GroupsBloc>(context).state.selectedGroup;
    double howMuchDoIMyFriend = 0;

    for (final GroupSpendingModel spendingDetail in state.spendingsDetails) {
      if (spendingDetail.user.id == me.uid) {
        try {
          SpendingModel spending = state.spendingsWhereIDidNotPay.firstWhere(
            (spendingWhereIDidNotPay) =>
                spendingWhereIDidNotPay.spendingId ==
                    spendingDetail.spending.id &&
                spendingWhereIDidNotPay.paidBy.id == friend.uid &&
                spendingWhereIDidNotPay.group.id == currentGroup?.groupId,
          );
          spending.paidBy;
          howMuchDoIMyFriend += spendingDetail.amountToPay;
        } catch (e) {
          howMuchDoIMyFriend;
        }
      }
    }

    for (final PaymentModel paymentMadeByMe in state.paymentsMadeByMe) {
      if (paymentMadeByMe.receiver.id == friend.uid &&
          currentGroup?.groupId == paymentMadeByMe.group.id) {
        howMuchDoIMyFriend -= paymentMadeByMe.amount;
      }
    }
    if (howMuchDoIMyFriend <= 0) {
      return const Text("No le debes ningún monto a este usuario.");
    }
    return Text(
        "Le debes un total de \$${howMuchDoIMyFriend.toStringAsFixed(2)}");
  }
}
