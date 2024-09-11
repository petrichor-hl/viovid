import 'package:flutter_bloc/flutter_bloc.dart';

class VideoState {
  // bool isPlaying;
  bool isFullScreen;
  double progress;
  // double volume;

  VideoState({
    this.isFullScreen = false,
    this.progress = 0,
  });

  VideoState copyWith({bool? isFullScreen, double? progress}) {
    return VideoState(
      // isPlaying: isPlaying ?? this.isPlaying,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      progress: progress ?? this.progress,
    );
  }
}

class VideoStateCubit extends Cubit<VideoState> {
  VideoStateCubit() : super(VideoState());

  // Hàm để cập nhật tiến trình của video
  void setProgress(double newProgress) {
    // print('videoState.progress changed');
    emit(state.copyWith(progress: newProgress));
  }

  void toggleFullScreen() {
    emit(state.copyWith(isFullScreen: !state.isFullScreen));
  }
}
