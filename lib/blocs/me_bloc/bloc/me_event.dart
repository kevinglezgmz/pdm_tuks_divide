part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object> get props => [];
}

class UpdateMeEvent extends MeEvent {
  final UserModel? newMe;

  const UpdateMeEvent({required this.newMe});

  @override
  List<Object> get props => [newMe ?? "No user"];
}
