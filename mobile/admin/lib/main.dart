import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/repositories/global/waste_repository.dart';
import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/data/repositories/users/collector_repository.dart';
import 'package:diakron_admin/data/repositories/users/participant_repository.dart';
import 'package:diakron_admin/data/repositories/users/store_repository.dart';
import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/l10n/app_localizations.dart';
import 'package:diakron_admin/routing/router.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
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
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));

  // Manual Dependency Injection for Global Data
  final dbService = DatabaseService();
  final wasteRepo = WasteRepository(databaseService: dbService);

  // Await the specific data your app needs to function
  await wasteRepo.init();

  runApp(
    MultiProvider(
      providers: [
        // Database service already instanced
        Provider<DatabaseService>.value(value: dbService),
        Provider<WasteRepository>.value(value: wasteRepo),
        Provider<AuthService>(create: (_) => AuthService()),

        Provider<AdminRepository>(
          create: (context) {
            return AdminRepository(
              databaseService: context.read<DatabaseService>(),
            );
          },
        ),
        Provider<CollectionCenterRepository>(
          create: (context) {
            return CollectionCenterRepository(
              databaseService: context.read<DatabaseService>(),
            );
          },
        ),

        Provider<ParticipantRepository>(
          create: (context) {
            return ParticipantRepository(
              databaseService: context.read<DatabaseService>(),
            );
          },
        ),
        Provider<StoreRepository>(
          create: (context) {
            return StoreRepository(
              databaseService: context.read<DatabaseService>(),
            );
          },
        ),
        Provider<CollectorRepository>(
          create: (context) => CollectorRepository(
            databaseService: context.read<DatabaseService>(),
          ),
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

      title: 'Diakron Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.greenDiakron1,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),

      routerConfig: router(authRepository),
    );
  }
}
