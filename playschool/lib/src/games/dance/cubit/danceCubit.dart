import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

class DanceCubit extends Cubit<DanceState> {
  DanceCubit() : super(DanceState()) {}

  Future<void> loadVideo(String videoPath) async {
    if (state.videoController != null) { videoDispose(); }

    final controller = VideoPlayerController.asset(videoPath);
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(0.5);
    controller.play();

    emit(state.copyWith(videoController: controller));
  }

  void playVideo() {
    state.videoController?.play();
  }

  void pauseVideo() {
    state.videoController?.pause();
  }

  void videoDispose() {
    state.videoController!.dispose();
  }
}

enum DanceStatus {
  init,
  loading,
  complete,
  error
}

class DanceState {
  final VideoPlayerController? videoController;
  final DanceStatus danceStatus;

  const DanceState ({
    this.videoController,
    this.danceStatus = DanceStatus.init,
  });

  DanceState copyWith ({
    VideoPlayerController? videoController,
    DanceStatus? danceStatus,
  }) {
    return DanceState(
      videoController: videoController ?? this.videoController,
      danceStatus: danceStatus ?? this.danceStatus,
    );
  }

}