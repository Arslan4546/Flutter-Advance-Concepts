part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraSuccess extends CameraState {
  final File imageFile;

  const CameraSuccess(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class CameraFailure extends CameraState {
  final String error;

  const CameraFailure(this.error);

  @override
  List<Object?> get props => [error];
}
