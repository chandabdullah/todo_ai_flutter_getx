import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_ai/app/services/speech_service.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/hive_service.dart';
import 'app/services/sync_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env.prod"); // Load environment variables
  } catch (e) {
    // print(File('.env.prod').existsSync());
    print('----------------------------'); // Print error if any
    print('Error loading .env file: $e'); // Print error if any
    print('----------------------------'); // Print error if any
  }

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService().init(); // open Hive boxes

  // Initialize ThemeService
  await ThemeService().init();

  // Start SyncService (to handle offline → online sync automatically)
  await SyncService().init();

  await SpeechService().init();

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "TODO AI",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().getThemeMode(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
