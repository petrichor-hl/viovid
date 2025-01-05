import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/config/app_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kpaxjjmelbqpllxenpxz.supabase.co',
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    authOptions: const FlutterAuthClientOptions(
      // authFlowType: AuthFlowType.pkce,
      authFlowType: AuthFlowType.implicit,
    ),
  );

  OpenAI.apiKey = openAIApiKey;

  runApp(const MyApp());
  // flutter run -d chrome --web-renderer html --dart-define-from-file=lib/config/.env
  // admin@viovid.com
  // admin123
}

const openAIApiKey = String.fromEnvironment('OPEN_AI_API_KEY');
final supabase = Supabase.instance.client;
const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
const baseAvatarUrl =
    'https://kpaxjjmelbqpllxenpxz.supabase.co/storage/v1/object/public/avatar/';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VioVid',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
          activeTrackColor: primaryColor,
          thumbColor: primaryColor,
          valueIndicatorColor: primaryColor,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            fixedSize: const Size.fromHeight(48),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: MaterialStateOutlineInputBorder.resolveWith(
            (states) {
              if (states.contains(WidgetState.focused)) {
                return const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: Color(0xFF695CFE), width: 2),
                );
              } else if (states.contains(WidgetState.hovered)) {
                return OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(
                      color: const Color(0xFF695CFE).withOpacity(0.3),
                      width: 1),
                );
              }
              return const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(color: Colors.black26),
              );
            },
          ),
        ),
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('vi'),
      // ],
      // locale: const Locale('vi'),
    );
  }
}
