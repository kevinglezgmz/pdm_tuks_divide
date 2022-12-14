part of 'spendings_bloc.dart';

abstract class SpendingsState extends Equatable {
  const SpendingsState();

  @override
  List<Object> get props => [];
}

class SpendingsUseState extends SpendingsState {
  final String spendingAmount;
  final String spendingDescription;
  final String spendingPictureUrl;
  final DistributionType spendingDistributionType;
  final Map<UserModel, bool> userToEqualDistributionAmount;
  final Map<UserModel, double?> userToUnEqualDistributionAmount;
  final Map<UserModel, double?> userToPercentDistributionAmount;
  final UserModel? payer;
  final bool isSaving;
  final bool saved;
  final List<UserModel> membersInGroup;
  final GroupModel? selectedGroup;

  const SpendingsUseState({
    this.spendingDistributionType = DistributionType.equal,
    this.spendingAmount = '',
    this.spendingPictureUrl = '',
    this.spendingDescription = '',
    this.userToEqualDistributionAmount = const {},
    this.userToUnEqualDistributionAmount = const {},
    this.userToPercentDistributionAmount = const {},
    this.payer,
    this.isSaving = false,
    this.saved = false,
    this.membersInGroup = const [],
    this.selectedGroup,
  });

  SpendingsUseState copyWith({
    String? spendingAmount,
    String? spendingDescription,
    String? spendingPictureUrl,
    DistributionType? spendingDistributionType,
    Map<UserModel, bool>? userToEqualDistributionAmount,
    Map<UserModel, double?>? userToUnEqualDistributionAmount,
    Map<UserModel, double?>? userToPercentDistributionAmount,
    UserModel? payer,
    bool? isSaving,
    bool? saved,
    List<UserModel>? membersInGroup,
    GroupModel? selectedGroup,
  }) {
    return SpendingsUseState(
      spendingAmount: spendingAmount ?? this.spendingAmount,
      spendingDescription: spendingDescription ?? this.spendingDescription,
      spendingPictureUrl: spendingPictureUrl ?? this.spendingPictureUrl,
      spendingDistributionType:
          spendingDistributionType ?? this.spendingDistributionType,
      userToEqualDistributionAmount:
          userToEqualDistributionAmount ?? this.userToEqualDistributionAmount,
      userToUnEqualDistributionAmount: userToUnEqualDistributionAmount ??
          this.userToUnEqualDistributionAmount,
      userToPercentDistributionAmount: userToPercentDistributionAmount ??
          this.userToPercentDistributionAmount,
      payer: payer ?? this.payer,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      membersInGroup: membersInGroup ?? this.membersInGroup,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }

  @override
  List<Object> get props => [
        spendingAmount,
        spendingDescription,
        spendingPictureUrl,
        spendingDistributionType,
        userToEqualDistributionAmount,
        userToUnEqualDistributionAmount,
        userToPercentDistributionAmount,
        payer ?? 'Payer',
        isSaving,
        saved,
        membersInGroup,
        selectedGroup ?? "GroupModel",
      ];
}

class NullableSpendingsUseState extends SpendingsState {
  final String? spendingAmount;
  final String? spendingDescription;
  final String? spendingPictureUrl;
  final DistributionType? spendingDistributionType;
  final Map<UserModel, bool>? userToEqualDistributionAmount;
  final Map<UserModel, double?>? userToUnEqualDistributionAmount;
  final Map<UserModel, double?>? userToPercentDistributionAmount;
  final UserModel? payer;
  final bool? isSaving;
  final bool? saved;
  final List<UserModel>? membersInGroup;
  final GroupModel? selectedGroup;

  const NullableSpendingsUseState({
    this.spendingDistributionType,
    this.spendingAmount,
    this.spendingPictureUrl,
    this.spendingDescription,
    this.userToEqualDistributionAmount,
    this.userToUnEqualDistributionAmount,
    this.userToPercentDistributionAmount,
    this.payer,
    this.isSaving,
    this.saved,
    this.membersInGroup,
    this.selectedGroup,
  });

  @override
  List<Object> get props => [
        spendingAmount ?? "null",
        spendingDescription ?? "null",
        spendingPictureUrl ?? "null",
        spendingDistributionType ?? "null",
        userToEqualDistributionAmount ?? "null",
        userToUnEqualDistributionAmount ?? "null",
        userToPercentDistributionAmount ?? "null",
        payer ?? "null",
        isSaving ?? "null",
        saved ?? "null",
        membersInGroup ?? "null",
        selectedGroup ?? "null",
      ];
}
