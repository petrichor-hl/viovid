import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/config/api.config.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/features/account_manament/cubit/account_list_cubit.dart';
import 'package:viovid/features/account_manament/data/account_list_api_service.dart';
import 'package:viovid/features/account_manament/data/account_list_repository.dart';
import 'package:viovid/features/topic_detail/cubit/topic_detail_cubit.dart';
import 'package:viovid/features/topic_detail/data/topic_detail_api_service.dart';
import 'package:viovid/features/topic_detail/data/topic_detail_repository.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/data/topic_management_api_service.dart';
import 'package:viovid/features/topic_management/data/topic_management_repository.dart';
import 'package:viovid/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/screens/admin/_layout/admin_layout.dart';
import 'package:viovid/screens/admin/account-management/account_management.dart';
import 'package:viovid/screens/admin/dashboard/dashboard.dart';
import 'package:viovid/screens/admin/film_management/film_management.dart';
import 'package:viovid/screens/admin/plan-management/plan_management.dart';
import 'package:viovid/screens/admin/topic_management/topic_detail/topic_detail.screen.dart';
import 'package:viovid/screens/admin/topic_management/topic_management.dart';
// import 'package:viovid/screens/admin/_layout/admin_layout.dart';
// import 'package:viovid/screens/admin/account-management/account_management.dart';
// import 'package:viovid/screens/admin/dashboard/dashboard.dart';
// import 'package:viovid/screens/admin/film_management/add_film.dart';
// import 'package:viovid/screens/admin/film_management/edit_film.dart';
// import 'package:viovid/screens/admin/film_management/film_management.dart';
// import 'package:viovid/screens/admin/plan-management/plan_management.dart';
// import 'package:viovid/screens/admin/topic_management/topic_management.dart';
import 'package:viovid/screens/auth/confirmed_sign_up.dart';
import 'package:viovid/screens/auth/sign_in.dart';
import 'package:viovid/screens/auth/sign_up.dart';
import 'package:viovid/screens/browse/browse.dart';
import 'package:viovid/screens/film_detail/film_detail.dart';
import 'package:viovid/screens/intro/intro.dart';
import 'package:viovid/screens/plans/register_plan.dart';
import 'package:viovid/screens/splash.dart';
import 'package:viovid/screens/video_player/video_player_view.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return await getRole() == 'end-user' ? '/browse' : '/admin/dashboard';
        }
        return null;
      },
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/intro',
      name: 'intro',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return await getRole() == 'end-user' ? '/browse' : '/admin/dashboard';
        }
        return null;
      },
      builder: (ctx, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return await getRole() == 'end-user' ? '/browse' : '/admin/dashboard';
        }
        return null;
      },
      builder: (ctx, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return await getRole() == 'end-user' ? '/browse' : '/admin/dashboard';
        }
        return null;
      },
      builder: (ctx, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/confirmed-sign-up',
      name: 'confirmed-sign-up',
      redirect: (context, state) {
        // Ex: http://localhost:5416/#/confirmed-sign-up#access_token=eyJhbGciOiJIUzI1NiIsImtpZCI6IlV5T3p1UTE3UVNNRjgzbXEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2twYXhqam1lbGJxcGxseGVucHh6LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJmOGYxZDBiYy0wYTU2LTRkZDItYTg2YS1lYTAxMTYwZWU5ZTUiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzI2MjI2NzM3LCJpYXQiOjE3MjYyMjMxMzcsImVtYWlsIjoiaGxnYW1lMTc0QGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnsiYXZhdGFyX3VybCI6ImRlZmF1bHRfYXZ0LnBuZyIsImRvYiI6IjAxLzA1LzIwMDMiLCJlbWFpbCI6ImhsZ2FtZTE3NEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZ1bGxfbmFtZSI6IlRhbmcgVGhpIEtpbSBOZ3V5ZW4iLCJwYXNzd29yZCI6IjEyMzQ1NiIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiZjhmMWQwYmMtMGE1Ni00ZGQyLWE4NmEtZWEwMTE2MGVlOWU1In0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib3RwIiwidGltZXN0YW1wIjoxNzI2MjIzMTM3fV0sInNlc3Npb25faWQiOiI2MWU1YmVhMS04MDNlLTQ5NDMtODU1Ni1hZGQwZjY4N2YzZTYiLCJpc19hbm9ueW1vdXMiOmZhbHNlfQ.Q_iao7y0KXVn56s2PB1drplNHrQHlwl1Cm4BBNVFlQc&expires_at=1726226737&expires_in=3600&refresh_token=7RVBNzh81-ZyEpNbYiUqCg&token_type=bearer&type=signup
        final params = Uri.splitQueryString(state.uri.fragment);
        if (params['refresh_token'] == null) {
          return '/intro';
        }
        return null;
      },
      builder: (ctx, state) {
        final params = Uri.splitQueryString(state.uri.fragment);
        return ConfirmedSignUp(
          refreshToken: params['refresh_token']!,
        );
      },
    ),
    GoRoute(
      path: '/browse',
      name: 'browse',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session == null) {
          return '/intro';
        } else {
          if (await getRole() == 'admin') {
            return '/admin/dashboard';
          }
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
    GoRoute(
      path: '/register-plan',
      name: 'register-plan',
      redirect: (context, state) async {
        final session = supabase.auth.currentSession;
        if (session != null) {
          final userRole = await getRole();
          if (userRole == 'admin') {
            return '/admin/dashboard';
          } else {
            bool isNormalUser = profileData['end_date'] == null ||
                (profileData['end_date'] != null &&
                    DateTime.tryParse(profileData['end_date']) != null &&
                    DateTime.parse(profileData['end_date'])
                        .isBefore(DateTime.now()));
            return isNormalUser ? null : '/browse';
          }
        }

        return '/intro';
      },
      builder: (ctx, state) => const RegisterPlan(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin',
          name: 'admin',
          redirect: (context, state) {
            return '/admin/dashboard';
          },
        ),
        GoRoute(
          path: '/admin/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/admin/plan-management',
          name: 'plan-management',
          builder: (context, state) => const PlanManagementScreen(),
        ),
        GoRoute(
          path: '/admin/film-management',
          name: 'film-management',
          builder: (context, state) => const FilmManagementScreen(),
          // routes: [
          //   GoRoute(
          //     path: 'add',
          //     name: 'add-film',
          //     builder: (context, state) => const AddFilm(),
          //   ),
          //   GoRoute(
          //     path: 'edit/:filmId',
          //     name: 'edit-film',
          //     // builder: (context, state) => EditFilm(
          //     //   filmId: state.pathParameters['filmId']!,
          //     // ),
          //     builder: (ctx, state) => RepositoryProvider(
          //       create: (context) => SelectedFilmRepo(),
          //       child: EditFilm(
          //         filmId: state.pathParameters['filmId']!,
          //       ),
          //     ),
          //   )
          // ],
        ),
        GoRoute(
          path: '/admin/topic-management',
          name: 'topic-management',
          builder: (context, state) => BlocProvider(
            create: (context) => TopicManagementCubit(
              TopicManagementRepository(
                topicManagementApiService: TopicManagementApiService(dio),
              ),
            ),
            child: const TopicManagementScreen(),
          ),
          routes: [
            GoRoute(
              path: ':topicId',
              name: 'topic-detail',
              builder: (context, state) {
                return BlocProvider(
                  create: (context) => TopicDetailCubit(
                    TopicDetailRepository(
                      topicDetailApiService: TopicDetailApiService(dio),
                    ),
                  ),
                  child: TopicDetailScreen(
                    topicId: state.pathParameters['topicId']!,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/admin/account-management',
          name: 'account-management',
          builder: (context, state) => BlocProvider(
            create: (context) => AccountListCubit(
              AccountListRepository(
                accountListApiService: AccountListApiService(dio),
              ),
            ),
            child: const AccountManagementScreen(),
          ),
        ),
      ],
    ),
  ],
);
