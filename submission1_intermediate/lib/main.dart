import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:submission1_intermediate/provider/localization_provider.dart';
import 'data/api/api_service.dart';
import 'data/preference/auth_preference.dart';
import 'l10n/app_localizations.dart';
import 'provider/auth_provider.dart';
import 'provider/story_provider.dart';
import 'routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final authPreferences = AuthPreferences();

  final authProvider = AuthProvider(
    apiService: apiService,
    authPreferences: authPreferences,
  );

  final storyProvider = StoryProvider(
    apiService: apiService,
    authPreferences: authPreferences,
  );
  authProvider.onAuthSuccess = () {
    storyProvider.fetchAllStories();
  };

  authProvider.checkLoginStatus();
  final router = AppRouter.createRouter(authProvider);

  runApp(
    MyApp(
      authProvider: authProvider,
      storyProvider: storyProvider,
      router: router,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final StoryProvider storyProvider;
  final GoRouter router;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.storyProvider,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: storyProvider),
        ChangeNotifierProvider(create: (context) => LocalizationProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context,locProvider, _) {
          return MaterialApp.router(
            locale: locProvider.locale,
            onGenerateTitle: (context) {
              return AppLocalizations.of(context)!.titleApp;
            },
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', ''), // Bahasa Indonesia (Utama)
              Locale('en', ''), // Bahasa Inggris
            ],
            routerConfig: router,
          );
        }
      ),
    );
  }
}
