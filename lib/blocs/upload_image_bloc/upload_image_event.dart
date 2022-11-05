part of 'upload_image_bloc.dart';

abstract class UploadImageEvent extends Equatable {
  const UploadImageEvent();

  @override
  List<dynamic> get props => [];
}

class UploadNewImageEvent extends UploadImageEvent {
  final String collection;
  final String typeOfUpload;

  UploadNewImageEvent(this.collection, this.typeOfUpload);

  @override
  List<dynamic> get props => [collection, typeOfUpload];
}
