import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'me_event.dart';
part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeUseState> {
  MeBloc() : super(const MeUseState()) {
    on<UpdateMeEvent>(_updateMeEventHandler);
  }

  void _updateMeEventHandler(UpdateMeEvent event, Emitter<MeUseState> emit) {
    emit(MeUseState(me: event.newMe));
  }
}
