import 'package:auth_practices/core/services/camera_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

part 'camera_event.dart';
part 'camera_states.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraService cameraService;

  CameraBloc(this.cameraService) : super(CameraInitial()) {
    on<CaptureImageRequested>(_captureImage);
    on<RemoveCapturedImage>(_removeImage);
  }

  Future<void> _captureImage(
    CaptureImageRequested event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoading());

    try {
      final File? image = await cameraService.captureImage();

      if (image != null) {
        emit(CameraSuccess(image));
      } else {
        emit(CameraInitial());
      }
    } catch (e) {
      emit(CameraFailure(e.toString()));
    }
  }

  void _removeImage(RemoveCapturedImage event, Emitter<CameraState> emit) {
    emit(CameraInitial());
  }
}
