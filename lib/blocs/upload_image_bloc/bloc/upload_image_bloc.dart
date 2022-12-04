import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_repository.dart';

part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  final UploadImageRepository _uploadImageRepository;
  String? uploadedImageUrl;

  UploadImageBloc({required uploadImageRepository})
      : _uploadImageRepository = uploadImageRepository,
        super(UploadImageInitialState()) {
    on<UploadNewImageEvent>(_uploadNewImage);
    on<ResetUploadImageBloc>(_resetUploadImageBloc);
  }

  FutureOr<void> _uploadNewImage(event, emit) async {
    emit(UploadingImageState());
    try {
      bool permissionGranted = event.typeOfUpload == "camera"
          ? await _requestPermission(Permission.camera)
          : await _requestPermission(Permission.storage);
      if (permissionGranted) {
        String imgUrl = await _uploadImageRepository.pickImage(
          event.collection,
          event.typeOfUpload,
        );
        uploadedImageUrl = imgUrl;
        emit(UploadingSuccessfulState());
      } else {
        throw "Permissions not granted";
      }
    } catch (error) {
      emit(UploadErrorState(message: error));
    }
  }

  FutureOr<void> _resetUploadImageBloc(
      ResetUploadImageBloc event, Emitter<UploadImageState> emit) {
    uploadedImageUrl = null;
    emit(UploadImageInitialState());
  }
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
