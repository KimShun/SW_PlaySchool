import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

class PopDanceCubit extends Cubit<PopDanceState> {
  PopDanceCubit() : super(PopDanceState()) {}

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

enum PopDanceStatus {
  init,
  loading,
  complete,
  error
}

class PopDanceState {
  final VideoPlayerController? videoController;
  final PopDanceStatus popDanceStatus;

  const PopDanceState ({
    this.videoController,
    this.popDanceStatus = PopDanceStatus.init,
  });

  PopDanceState copyWith ({
    VideoPlayerController? videoController,
    PopDanceStatus? popDanceStatus,
  }) {
    return PopDanceState(
      videoController: videoController ?? this.videoController,
      popDanceStatus: popDanceStatus ?? this.popDanceStatus,
    );
  }

}