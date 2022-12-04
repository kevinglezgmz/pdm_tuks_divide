part of 'me_bloc.dart';

abstract class MeState extends Equatable {
  const MeState();

  @override
  List<Object> get props => [];
}

class MeUseState extends MeState {
  final UserModel? me;

  const MeUseState({this.me});

  @override
  List<Object> get props => [me ?? "No user"];
}
