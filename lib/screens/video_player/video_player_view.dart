import 'dart:async';
import 'dart:js_interop';

import 'package:gap/gap.dart';
import 'package:viovid/screens/video_player/components/speed_control.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/models/episode.dart';
import 'package:viovid/models/season.dart';
import 'package:viovid/screens/video_player/components/back_control.dart';
import 'package:viovid/screens/video_player/components/forward_control.dart';
import 'package:viovid/screens/video_player/components/full_screen_control.dart';
import 'package:viovid/screens/video_player/components/next_episode_control.dart';
import 'package:viovid/screens/video_player/components/play_pause_button.dart';
import 'package:viovid/screens/video_player/components/progress_bar.dart';
import 'package:viovid/screens/video_player/components/video_header.dart';
import 'package:viovid/screens/video_player/components/volume_control.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.filmName,
    required this.seasons,
    required this.firstEpisodeIdToPlay,
  });

  final String? filmName;
  final List<Season>? seasons;
  final String firstEpisodeIdToPlay;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;

  bool _controlsOverlayVisible = false;
  late Timer _controlsTimer = Timer(Duration.zero, () {});

  // late bool isMovie;

  late int _currentEpisodeIndex;
  late int _currentSeasonIndex;

  late String filmName;
  late List<Season> seasons;

  void _toggleControlsOverlay() {
    _controlsTimer.cancel();

    setState(() {
      _controlsOverlayVisible = !_controlsOverlayVisible;
    });

    if (_controlsOverlayVisible) {
      _startCountdownToDismissControls();
    }
  }

  void _startCountdownToDismissControls() {
    _controlsTimer.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      setState(() {
        _controlsOverlayVisible = false;
      });
    });
  }

  void _onVideoPlayerStateChanged() {
    context.read<VideoStateCubit>().setProgress(
        _videoPlayerController.value.position.inMilliseconds /
            _videoPlayerController.value.duration.inMilliseconds);
  }

  // Note: callback được gọi khi event fullscreenchange được trigger
  // package:web/web.dart (để ý cuối function có .toJS)
  // https://dart.dev/interop/js-interop/package-web#type-signatures
  late final _onFullScreenChanged = () {
    if (web.document.fullscreen) {
      print('LOG: Chế độ toàn màn hình');
    } else {
      print('LOG: Thoát chế độ toàn màn hình');
    }
    context.read<VideoStateCubit>().toggleFullScreen();
  }.toJS;

  void setVideoController(Episode episode) {
    _controlsTimer.cancel();

    setState(() {
      _controlsOverlayVisible = false;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(episode.linkEpisode),
    );

    _videoPlayerController.initialize().then(
      (value) {
        _videoPlayerController.addListener(_onVideoPlayerStateChanged);

        // Đăng ký lắng nghe sự kiện fullscreenchange
        web.window.addEventListener('fullscreenchange', _onFullScreenChanged);

        setState(() {
          _controlsOverlayVisible = true;
        });

        _videoPlayerController.play().then((_) {
          _startCountdownToDismissControls();
        });
      },
      onError: (error) => print(error),
    );
  }

  late final _future = _preProcessing();
  Future<void> _preProcessing() async {
    if (widget.filmName == null && widget.seasons == null) {
      final filmId = GoRouterState.of(context).pathParameters['filmId']!;
      final selectedFilm = await SelectedFilmRepo().fetchFilm(filmId);

      filmName = selectedFilm.name;
      seasons = selectedFilm.seasons;
    } else {
      filmName = widget.filmName!;
      seasons = widget.seasons!;
    }

    for (int i = 0; i < seasons.length; ++i) {
      for (int j = 0; j < seasons[i].episodes.length; ++j) {
        if (seasons[i].episodes[j].episodeId == widget.firstEpisodeIdToPlay) {
          setVideoController(seasons[i].episodes[j]);
          _currentSeasonIndex = i;
          _currentEpisodeIndex = j;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _controlsTimer.cancel();

    // removeEventListener khi rời khỏi route này
    web.window.removeEventListener('fullscreenchange', _onFullScreenChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Có lỗi xảy ra khi truy vấn thông tin phim',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final isCanGoToNextEpisode =
                !(_currentSeasonIndex == seasons.length - 1 &&
                    _currentEpisodeIndex ==
                        seasons[_currentSeasonIndex].episodes.length - 1);

            void goToNextEpisode() {
              late final String nextEpisodeId;
              if (_currentEpisodeIndex ==
                  seasons[_currentSeasonIndex].episodes.length - 1) {
                nextEpisodeId =
                    seasons[_currentSeasonIndex + 1].episodes[0].episodeId;
                // context.go('')
              } else {
                nextEpisodeId = seasons[_currentSeasonIndex]
                    .episodes[_currentEpisodeIndex + 1]
                    .episodeId;
              }
              final regExp = RegExp(r'episode/[^/]+/watching');
              context.go(
                GoRouterState.of(context).matchedLocation.replaceAllMapped(
                      regExp,
                      (match) => 'episode/$nextEpisodeId/watching',
                    ),
                extra: {
                  'filmName': filmName,
                  'seasons': seasons,
                },
              );
            }

            return GestureDetector(
              onTap: _toggleControlsOverlay,
              // onTap: _videoPlayerController.value.isInitialized
              //     ? _toggleControlsOverlay
              //     : null,
              child: Stack(
                children: [
                  /* Video */
                  Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.isInitialized
                          ? _videoPlayerController.value.aspectRatio
                          : 16 / 9,
                      child: _videoPlayerController.value.isInitialized
                          ? VideoPlayer(_videoPlayerController)
                          : const Center(
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: IgnorePointer(
                      ignoring: !_controlsOverlayVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            offset: _controlsOverlayVisible
                                ? const Offset(0, 0)
                                : const Offset(0, -1),
                            curve: Curves.easeInOut,
                            child: VideoHeader(
                              title:
                                  '${seasons[_currentSeasonIndex].name} - ${seasons[_currentSeasonIndex].episodes[_currentEpisodeIndex].title}',
                            ),
                          ),
                          const Spacer(),
                          // AnimatedOpacity(
                          //   opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                          //   duration: const Duration(milliseconds: 300),
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 40),
                          //     child: VolumeControl(
                          //       _videoPlayerController,
                          //       _startCountdownToDismissControls,
                          //     ),
                          //   ),
                          // ),
                          // const Spacer(),
                          AnimatedOpacity(
                            opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: ProgressBar(
                              _controlsOverlayVisible,
                              _videoPlayerController,
                              _startCountdownToDismissControls,
                              () => _controlsTimer.cancel(),
                              // NOT THE SAME FOR
                              // _controlsTimer.cancel,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                              child: Row(
                                children: [
                                  PlayPauseButton(
                                    _videoPlayerController,
                                    _startCountdownToDismissControls,
                                  ),
                                  const Gap(20),
                                  BackControl(
                                    _videoPlayerController,
                                    _startCountdownToDismissControls,
                                  ),
                                  const Gap(20),
                                  ForwardControl(
                                    _videoPlayerController,
                                    _startCountdownToDismissControls,
                                  ),
                                  const Gap(20),
                                  VolumeControl(
                                    _videoPlayerController,
                                    _startCountdownToDismissControls,
                                  ),
                                  const Spacer(),
                                  if (isCanGoToNextEpisode)
                                    NextEpisodeControl(
                                      goToNextEpisode,
                                    ),
                                  const Gap(20),
                                  SpeedControl(
                                    _videoPlayerController,
                                    _startCountdownToDismissControls,
                                  ),
                                  const Gap(20),
                                  FullScreenControl(
                                    _startCountdownToDismissControls,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
