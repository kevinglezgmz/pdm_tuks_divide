import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'spendings_event.dart';
part 'spendings_state.dart';

class SpendingsBloc extends Bloc<SpendingsEvent, SpendingsUseState> {
  final GroupsRepository _groupsRepository;

  double get unequalDistributionAccumulatedValue =>
      state.userToUnEqualDistributionAmount.values
          .map((value) => value ?? 0)
          .reduce((value, element) => value + element);

  Map<UserModel, TextEditingController>
      get emptyUserToTextEditingControllerMap {
    List<MapEntry<UserModel, double?>> distributionEntries =
        state.userToUnEqualDistributionAmount.entries.toList();
    Map<UserModel, TextEditingController> unequalUserToControllerMap =
        Map.fromEntries(
      distributionEntries.map((entry) {
        final controller = TextEditingController(text: entry.value?.toString());
        return MapEntry(entry.key, controller);
      }),
    );
    return unequalUserToControllerMap;
  }

  SpendingsBloc({required GroupsRepository groupsRepository})
      : _groupsRepository = groupsRepository,
        super(const SpendingsUseState()) {
    on<SpendingsResetBlocEvent>(_resetSpendingsBlocEventHandler);
    on<SpendingsSetInitialSpendingsEvent>(_setEmptyInitialSpendings);
    on<SpendingUpdateEvent>(_updateSpendingEventHandler);
    on<SaveSpendingEvent>(_saveSpendingEventHandler);
  }

  FutureOr<void> _resetSpendingsBlocEventHandler(
      SpendingsResetBlocEvent event, Emitter<SpendingsState> emit) async {
    emit(const SpendingsUseState());
  }

  FutureOr<void> _updateSpendingEventHandler(
      SpendingUpdateEvent event, Emitter<SpendingsUseState> emit) {
    SpendingsUseState newState = state.copyWith(
      spendingAmount: event.newState.spendingAmount,
      spendingDescription: event.newState.spendingDescription,
      spendingDistributionType: event.newState.spendingDistributionType,
      spendingPictureUrl: event.newState.spendingPictureUrl,
      userToEqualDistributionAmount:
          event.newState.userToEqualDistributionAmount,
      userToPercentDistributionAmount:
          event.newState.userToPercentDistributionAmount,
      userToUnEqualDistributionAmount:
          event.newState.userToUnEqualDistributionAmount,
      payer: event.newState.payer,
      isSaving: event.newState.isSaving,
      membersInGroup: event.newState.membersInGroup,
      saved: event.newState.saved,
      selectedGroup: event.newState.selectedGroup,
    );
    _updateState(
      emit,
      newState,
    );
  }

  void _updateState(Emitter<SpendingsState> emit, SpendingsUseState newState) {
    emit(state.copyWith(
      spendingAmount: newState.spendingAmount,
      spendingDescription: newState.spendingDescription,
      spendingDistributionType: newState.spendingDistributionType,
      spendingPictureUrl: newState.spendingPictureUrl,
      userToEqualDistributionAmount: newState.userToEqualDistributionAmount,
      userToPercentDistributionAmount: newState.userToPercentDistributionAmount,
      userToUnEqualDistributionAmount: newState.userToUnEqualDistributionAmount,
      payer: newState.payer,
      isSaving: newState.isSaving,
      membersInGroup: newState.membersInGroup,
      saved: newState.saved,
      selectedGroup: newState.selectedGroup,
    ));
  }

  void _setEmptyInitialSpendings(
      SpendingsSetInitialSpendingsEvent event, Emitter<SpendingsState> emit) {
    Map<UserModel, bool> userToEqualDistributionAmount = {};
    Map<UserModel, double?> userToUnEqualDistributionAmount = {};
    Map<UserModel, double?> userToPercentDistributionAmount = {};
    for (final user in state.membersInGroup) {
      userToEqualDistributionAmount[user] = true;
      userToUnEqualDistributionAmount[user] = null;
      userToPercentDistributionAmount[user] = null;
    }
    _updateState(
      emit,
      state.copyWith(
        userToEqualDistributionAmount: userToEqualDistributionAmount,
        userToUnEqualDistributionAmount: userToUnEqualDistributionAmount,
        userToPercentDistributionAmount: userToPercentDistributionAmount,
      ),
    );
  }

  Future<void> _saveSpendingEventHandler(
    SaveSpendingEvent event,
    Emitter<SpendingsUseState> emit,
  ) async {
    if (state.selectedGroup == null) {
      throw "Not in a group";
    }
    if (state.payer == null) {
      throw "No payer";
    }

    emit(state.copyWith(isSaving: true));
    final Map<UserModel, double> userToAmountToPayMap = {};
    final double totalAmount = double.tryParse(state.spendingAmount) ?? 0;

    if (state.spendingDistributionType == DistributionType.equal) {
      List<UserModel> participants = state.userToEqualDistributionAmount.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      double amountPerPerson =
          double.parse((totalAmount / participants.length).toStringAsFixed(2));
      for (final UserModel user in participants) {
        userToAmountToPayMap[user] = amountPerPerson;
      }
      if (amountPerPerson * participants.length != totalAmount) {
        double rest = double.parse((totalAmount -
                double.parse(
                  (amountPerPerson * participants.length).toStringAsFixed(2),
                ))
            .toStringAsFixed(2));
        int i = 0;
        while (rest > 0) {
          rest = double.parse((rest - 0.01).toStringAsFixed(2));
          userToAmountToPayMap[participants[i]] = double.parse(
            (userToAmountToPayMap[participants[i]]! + 0.01).toStringAsFixed(2),
          );
          i++;
          if (i == participants.length) {
            i = 0;
          }
        }
      }
    } else if (state.spendingDistributionType == DistributionType.unequal) {
      List<UserModel> participants = state
          .userToUnEqualDistributionAmount.entries
          .where((entry) => (entry.value ?? 0) > 0)
          .map((entry) => entry.key)
          .toList();
      for (final UserModel user in participants) {
        userToAmountToPayMap[user] =
            state.userToUnEqualDistributionAmount[user]!;
      }
    } else if (state.spendingDistributionType == DistributionType.percentage) {
      List<UserModel> participants = state
          .userToPercentDistributionAmount.entries
          .map((entry) => entry.key)
          .toList();
      double totalAccumulated = 0;
      for (final UserModel user in participants) {
        double? percent = state.userToPercentDistributionAmount[user];
        if (percent == null) {
          continue;
        }
        double amountToPay = double.parse(
          (totalAmount * percent / 100).toStringAsFixed(2),
        );
        totalAccumulated = double.parse(
          (totalAccumulated + amountToPay).toStringAsFixed(2),
        );
        userToAmountToPayMap[user] = amountToPay;
      }
      if (totalAccumulated != totalAmount) {
        double rest = double.parse(
          (totalAmount - totalAccumulated).toStringAsFixed(2),
        );
        int i = 0;
        while (rest > 0) {
          rest = double.parse((rest - 0.01).toStringAsFixed(2));
          userToAmountToPayMap[participants[i]] = double.parse(
            (userToAmountToPayMap[participants[i]]! + 0.01).toStringAsFixed(2),
          );
          i++;
          if (i == participants.length) {
            i = 0;
          }
        }
      }
    } else {
      emit(state.copyWith(saved: true, isSaving: false));
      return;
    }
    await _groupsRepository.saveSpendingForGroup(
      state.selectedGroup!,
      userToAmountToPayMap,
      totalAmount,
      state.spendingDescription,
      state.spendingPictureUrl,
      state.spendingDistributionType,
      state.payer!,
    );
    emit(state.copyWith(saved: true, isSaving: false));
  }
}
