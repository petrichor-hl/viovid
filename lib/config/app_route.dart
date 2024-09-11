import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/screens/auth/sign_in.dart';
import 'package:viovid/screens/browse/browse.dart';
import 'package:viovid/screens/film_detail/film_detail.dart';
import 'package:viovid/screens/intro/intro.dart';
import 'package:viovid/screens/splash.dart';
import 'package:viovid/screens/video_player/video_player_view.dart';

final session = supabase.auth.currentSession;

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/intro',
      name: 'intro',
      redirect: (context, state) {
        if (session != null) {
          return '/browse';
        }
        return null;
      },
      builder: (ctx, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      redirect: (context, state) {
        if (session != null) {
          return '/browse';
        }
        return null;
      },
      builder: (ctx, state) => const SignInScreen(),
    ),
    // GoRoute(
    //   path: '/sign-up',
    //   name: 'sign-up',
    //   builder: (ctx, state) => const SignUpScreen(),
    // ),
    GoRoute(
      path: '/browse',
      name: 'browse',
      redirect: (context, state) {
        final session = supabase.auth.currentSession;
        if (session == null) {
          return '/intro';
        }
        return null;
      },
      builder: (ctx, state) => const BrowseScreen(),
      routes: [
        GoRoute(
          path: 'film_detail/:filmId',
          name: 'film_detail',
          builder: (ctx, state) => RepositoryProvider(
            create: (context) => SelectedFilmRepo(),
            child: FilmDetail(
              filmId: state.pathParameters['filmId']!,
            ),
          ),
          routes: [
            GoRoute(
              path: 'episode/:episodeId/watching',
              name: 'episode_watching',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final episodeId = state.pathParameters['episodeId']!;
                return BlocProvider(
                  create: (ctx) => VideoStateCubit(),
                  child: VideoPlayerView(
                    key: ValueKey(episodeId),
                    filmName: extra?['filmName'],
                    seasons: extra?['seasons'],
                    firstEpisodeIdToPlay: episodeId,
                  ),
                );
              },
            ),
          ],
          // routes:
        ),
      ],
    ),
  ],
);
