part of 'participants_detail_bloc.dart';

abstract class ParticipantsDetailEvent extends Equatable {
  const ParticipantsDetailEvent();

  @override
  List<Object> get props => [];
}

class GetParticipantsDetailEvent extends ParticipantsDetailEvent {
  final String groupId;

  const GetParticipantsDetailEvent({required this.groupId});

  @override
  List<Object> get props => [groupId];
}
