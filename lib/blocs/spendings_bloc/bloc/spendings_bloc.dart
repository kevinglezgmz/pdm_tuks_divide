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
  final List<UserModel> _currentUsersInGroup = [];
  GroupModel? _currentGroup;

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
    on<SpendingUpdateEvent>(_updateSpendingEventHandler);
    on<SpendingLoadGroupMembersEvent>(_loadGroupMembersEventHandler);
    on<SaveSpendingEvent>(_saveSpendingEventHandler);
  }

  FutureOr<void> _resetSpendingsBlocEventHandler(
      SpendingsResetBlocEvent event, Emitter<SpendingsState> emit) async {
    emit(const SpendingsUseState());
    _setEmptyInitialSpendings(emit);
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
    ));
  }

  FutureOr<void> _loadGroupMembersEventHandler(
      SpendingLoadGroupMembersEvent event,
      Emitter<SpendingsUseState> emit) async {
    _currentUsersInGroup.clear();
    _currentGroup = event.group;
    try {
      final usersInGroup =
          await _groupsRepository.getMembersOfGroup(event.group);
      _currentUsersInGroup.addAll(usersInGroup);
      _setEmptyInitialSpendings(emit);
    } catch (e) {
      // Better handle the error
    }
  }

  void _setEmptyInitialSpendings(Emitter<SpendingsState> emit) {
    Map<UserModel, bool> userToEqualDistributionAmount = {};
    Map<UserModel, double?> userToUnEqualDistributionAmount = {};
    Map<UserModel, double?> userToPercentDistributionAmount = {};
    for (final user in _currentUsersInGroup) {
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
    if (_currentGroup == null) {
      throw "Not in a group";
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
      if (amountPerPerson * participants.length != totalAmount) {
        double rest = totalAmount - amountPerPerson * participants.length;
      }
      for (final UserModel user in participants) {
        userToAmountToPayMap[user] = amountPerPerson;
      }
      await _groupsRepository.saveSpendingForGroup(
        _currentGroup!,
        userToAmountToPayMap,
        totalAmount,
        state.spendingDescription,
        state.spendingPictureUrl,
        state.spendingDistributionType,
        userToAmountToPayMap.keys.first,
      );
      emit(state.copyWith(saved: true, isSaving: false));
    } else if (state.spendingDistributionType == DistributionType.unequal) {
    } else if (state.spendingDistributionType == DistributionType.percentage) {
    } else {
      return;
    }
  }
}
