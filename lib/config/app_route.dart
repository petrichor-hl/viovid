import 'package:go_router/go_router.dart';
import 'package:viovid/screens/auth/sign_in.dart';
import 'package:viovid/screens/browse/browse.dart';
import 'package:viovid/screens/film_detail/film_detail.dart';
import 'package:viovid/screens/intro/intro.dart';
import 'package:viovid/screens/splash.dart';

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
      builder: (ctx, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
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
      builder: (ctx, state) => const BrowseScreen(),
      routes: [
        GoRoute(
          path: 'film_detail/:filmId',
          name: 'film_detail',
          builder: (ctx, state) =>
              FilmDetail(filmId: state.pathParameters['filmId']!),
        ),
      ],
    ),
  ],
);
