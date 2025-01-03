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
