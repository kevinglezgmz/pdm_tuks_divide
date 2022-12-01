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
  final bool isSaving;
  final bool saved;

  const SpendingsUseState({
    this.spendingDistributionType = DistributionType.equal,
    this.spendingAmount = '',
    this.spendingPictureUrl = '',
    this.spendingDescription = '',
    this.userToEqualDistributionAmount = const {},
    this.userToUnEqualDistributionAmount = const {},
    this.userToPercentDistributionAmount = const {},
    this.isSaving = false,
    this.saved = false,
  });

  SpendingsUseState copyWith({
    String? spendingAmount,
    String? spendingDescription,
    String? spendingPictureUrl,
    DistributionType? spendingDistributionType,
    Map<UserModel, bool>? userToEqualDistributionAmount,
    Map<UserModel, double?>? userToUnEqualDistributionAmount,
    Map<UserModel, double?>? userToPercentDistributionAmount,
    bool? isSaving,
    bool? saved,
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
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
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
        isSaving
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
  final bool? isSaving;

  const NullableSpendingsUseState(
      {this.spendingDistributionType,
      this.spendingAmount,
      this.spendingPictureUrl,
      this.spendingDescription,
      this.userToEqualDistributionAmount,
      this.userToUnEqualDistributionAmount,
      this.userToPercentDistributionAmount,
      this.isSaving});

  @override
  List<Object> get props => [
        spendingAmount ?? "null",
        spendingDescription ?? "null",
        spendingPictureUrl ?? "null",
        spendingDistributionType ?? "null",
        userToEqualDistributionAmount ?? "null",
        userToUnEqualDistributionAmount ?? "null",
        userToPercentDistributionAmount ?? "null",
        isSaving ?? "null"
      ];
}
