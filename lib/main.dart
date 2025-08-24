import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ai/app/routes/app_pages.dart';
import '/theme/app_theme.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().init(); // make sure prefs are ready
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
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      themeMode: ThemeService().getThemeMode(),
      home: const HomeView(),
    );
  }
}
