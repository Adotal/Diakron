import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/data/services/auth_service.dart';
import 'package:diakron_stores/data/services/database_service.dart';
import 'package:diakron_stores/l10n/app_localizations.dart';
import 'package:diakron_stores/routing/router.dart';
import 'package:diakron_stores/ui/core/themes/colors.dart';
import 'package:diakron_stores/ui/upload_files/view_models/upload_files_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {


  // To load the .env file contents into dotenv.
  await dotenv.load(fileName: ".env");

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize supabase
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(
    MultiProvider(
       providers: [
        // Provider(create: (context) => AuthService()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        ChangeNotifierProvider(
          create: (context) =>
              StoreRepository(databaseService: context.read<DatabaseService>()),
        ),
        // AuthRepository is a ChangeNotifier, so we MUST use ChangeNotifierProxyProvider
        ChangeNotifierProxyProvider<AuthService, AuthRepository>(
          create: (context) =>
              AuthRepository(authService: context.read<AuthService>()),
          update: (context, authService, previousRepository) {
            // This ensures if AuthService ever changed, the repo stays updated
            return previousRepository ??
                AuthRepository(authService: authService);
          },
        ),
        ChangeNotifierProvider(create: (context) => UploadFilesViewModel(     
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<StoreRepository>(),
        )),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.read() here because the Router handles its own
    // listeners via the refreshListenable property we set up earlier.
    final authRepository = context.read<AuthRepository>();

    return MaterialApp.router(
      // For localization and internation
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: [
        Locale('es'), // Spanish
        Locale('en'), //- English
      ],

      // Default locale
      locale: Locale("es"),

      title: 'Diakron Tienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.greenDiakron1,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Arial', // Fuente genérica
      ),

      routerConfig: router(authRepository),
    );
  }
}
