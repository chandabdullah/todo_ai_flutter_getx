import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ai/app/routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO AI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
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
