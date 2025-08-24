import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO AI"),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome to TODO AI 🚀", style: theme.textTheme.titleLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
