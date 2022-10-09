import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_me_event.dart';
part 'delete_me_state.dart';

class DeleteMeBloc extends Bloc<DeleteMeEvent, DeleteMeState> {
  DeleteMeBloc() : super(DeleteMeInitial()) {
    on<DeleteMeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
