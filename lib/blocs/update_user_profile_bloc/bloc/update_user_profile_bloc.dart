import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_repository.dart';

part 'update_user_profile_event.dart';
part 'update_user_profile_state.dart';

class UpdateUserProfileBloc
    extends Bloc<UpdateUserProfileEvent, UpdateUserProfileState> {
  final UpdateUserProfileRepository _updateUserProfileRepository;
  UpdateUserProfileBloc({required updateUserProfileRepository})
      : _updateUserProfileRepository = updateUserProfileRepository,
        super(UpdateUserProfileInitialState()) {
    on<UpdateNewUserProfileInfoEvent>(_updateUserProfileHandler);
  }

  FutureOr<void> _updateUserProfileHandler(event, emit) async {
    try {
      final userUpdated = await _updateUserProfileRepository.updateUserProfile(
          event.uid,
          event.firstName,
          event.lastName,
          event.imageUrl,
          event.displayName);
      emit(UpdateUserProfileLoadedState());
    } catch (error) {
      emit(UpdateUserProfileErrorState());
    }
  }
}
