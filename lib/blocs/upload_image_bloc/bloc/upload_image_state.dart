part of 'upload_image_bloc.dart';

abstract class UploadImageState extends Equatable {
  const UploadImageState();

  @override
  List<Object> get props => [];
}

class UploadImageInitialState extends UploadImageState {}

class UploadingImageState extends UploadImageState {}

class UploadingSuccessfulState extends UploadImageState {}

class UploadErrorState extends UploadImageState {
  final Object message;

  const UploadErrorState({required this.message});

  @override
  List<Object> get props => [];
}
