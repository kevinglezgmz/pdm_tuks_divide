part of 'participants_detail_bloc.dart';

abstract class ParticipantsDetailState extends Equatable {
  const ParticipantsDetailState();

  @override
  List<Object> get props => [];
}

class ParticipantsDetailInitialState extends ParticipantsDetailState {}

class ParticipantsLoadingDetailState extends ParticipantsDetailState {}

class ParticipantsLoadingErrorState extends ParticipantsDetailState {}

class ParticipantsLoadedDetailState extends ParticipantsDetailState {
  final List<UserModel> participants;
  final GroupModel group;

  const ParticipantsLoadedDetailState(
      {required this.participants, required this.group});

  @override
  List<Object> get props => [participants, group];
}
