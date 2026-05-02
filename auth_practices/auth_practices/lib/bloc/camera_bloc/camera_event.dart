part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class CaptureImageRequested extends CameraEvent {}

class RemoveCapturedImage extends CameraEvent {}
