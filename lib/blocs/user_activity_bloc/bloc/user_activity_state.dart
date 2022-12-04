part of 'user_activity_bloc.dart';

abstract class UserActivityState extends Equatable {
  const UserActivityState();

  @override
  List<dynamic> get props => [];
}

class UserActivityUseState extends UserActivityState {
  final List<PaymentModel> paymentsMadeByMe;
  final List<PaymentModel> paymentsMadeToMe;
  final List<SpendingModel> spendingsWhereIPaid;
  final List<SpendingModel> spendingsWhereIDidNotPay;
  final List<GroupSpendingModel> spendingsDetails;
  final bool isLoadingSpendings;
  final bool isLoadingPaymentsToMe;
  final bool isLoadingPaymentsByMe;
  final Map<String, UserModel> userIdToUserMap;

  const UserActivityUseState({
    this.paymentsMadeByMe = const [],
    this.paymentsMadeToMe = const [],
    this.spendingsWhereIPaid = const [],
    this.spendingsWhereIDidNotPay = const [],
    this.spendingsDetails = const [],
    this.isLoadingSpendings = false,
    this.isLoadingPaymentsToMe = false,
    this.isLoadingPaymentsByMe = false,
    this.userIdToUserMap = const {},
  });

  UserActivityUseState copyWith({
    List<PaymentModel>? paymentsMadeByMe,
    List<PaymentModel>? paymentsMadeToMe,
    List<SpendingModel>? spendingsWhereIPaid,
    List<SpendingModel>? spendingsWhereIDidNotPay,
    List<GroupSpendingModel>? spendingsDetails,
    bool? isLoadingSpendings,
    bool? isLoadingPaymentsToMe,
    bool? isLoadingPaymentsByMe,
    Map<String, UserModel>? userIdToUserMap,
  }) {
    return UserActivityUseState(
      paymentsMadeByMe: paymentsMadeByMe ?? this.paymentsMadeByMe,
      paymentsMadeToMe: paymentsMadeToMe ?? this.paymentsMadeToMe,
      spendingsWhereIPaid: spendingsWhereIPaid ?? this.spendingsWhereIPaid,
      spendingsWhereIDidNotPay:
          spendingsWhereIDidNotPay ?? this.spendingsWhereIDidNotPay,
      spendingsDetails: spendingsDetails ?? this.spendingsDetails,
      isLoadingPaymentsByMe:
          isLoadingPaymentsByMe ?? this.isLoadingPaymentsByMe,
      isLoadingPaymentsToMe:
          isLoadingPaymentsToMe ?? this.isLoadingPaymentsToMe,
      isLoadingSpendings: isLoadingSpendings ?? this.isLoadingSpendings,
      userIdToUserMap: userIdToUserMap ?? this.userIdToUserMap,
    );
  }

  @override
  List get props => [
        paymentsMadeByMe,
        paymentsMadeToMe,
        spendingsWhereIPaid,
        spendingsWhereIDidNotPay,
        spendingsDetails,
        isLoadingPaymentsByMe,
        isLoadingPaymentsToMe,
        isLoadingSpendings,
        userIdToUserMap,
      ];
}

class NullableUserActivityUseState extends UserActivityState {
  final List<PaymentModel>? paymentsMadeByMe;
  final List<PaymentModel>? paymentsMadeToMe;
  final List<SpendingModel>? spendingsWhereIPaid;
  final List<SpendingModel>? spendingsWhereIDidNotPay;
  final List<GroupSpendingModel>? spendingsDetails;
  final bool? isLoadingSpendings;
  final bool? isLoadingPaymentsToMe;
  final bool? isLoadingPaymentsByMe;
  final Map<String, UserModel>? userIdToUserMap;

  const NullableUserActivityUseState({
    this.paymentsMadeByMe,
    this.paymentsMadeToMe,
    this.spendingsWhereIPaid,
    this.spendingsWhereIDidNotPay,
    this.spendingsDetails,
    this.isLoadingSpendings,
    this.isLoadingPaymentsToMe,
    this.isLoadingPaymentsByMe,
    this.userIdToUserMap,
  });

  NullableUserActivityUseState copyWith({
    List<PaymentModel>? paymentsMadeByMe,
    List<PaymentModel>? paymentsMadeToMe,
    List<SpendingModel>? spendingsWhereIPaid,
    List<SpendingModel>? spendingsWhereIDidNotPay,
    List<GroupSpendingModel>? spendingsDetails,
    bool? isLoadingSpendings,
    bool? isLoadingPaymentsToMe,
    bool? isLoadingPaymentsByMe,
    Map<String, UserModel>? userIdToUserMap,
  }) {
    return NullableUserActivityUseState(
      paymentsMadeByMe: paymentsMadeByMe ?? this.paymentsMadeByMe,
      paymentsMadeToMe: paymentsMadeToMe ?? this.paymentsMadeToMe,
      spendingsWhereIPaid: spendingsWhereIPaid ?? this.spendingsWhereIPaid,
      spendingsWhereIDidNotPay:
          spendingsWhereIDidNotPay ?? this.spendingsWhereIDidNotPay,
      spendingsDetails: spendingsDetails ?? this.spendingsDetails,
      isLoadingPaymentsByMe:
          isLoadingPaymentsByMe ?? this.isLoadingPaymentsByMe,
      isLoadingPaymentsToMe:
          isLoadingPaymentsToMe ?? this.isLoadingPaymentsToMe,
      isLoadingSpendings: isLoadingSpendings ?? this.isLoadingSpendings,
      userIdToUserMap: userIdToUserMap ?? this.userIdToUserMap,
    );
  }

  @override
  List get props => [
        paymentsMadeByMe,
        paymentsMadeToMe,
        spendingsWhereIPaid,
        spendingsWhereIDidNotPay,
        spendingsDetails,
        isLoadingPaymentsByMe,
        isLoadingPaymentsToMe,
        isLoadingSpendings,
        userIdToUserMap,
      ];
}
