import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:todo_ai/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("TODO AI"),
            actions: [
              IconButton(
                icon: const Icon(HugeIcons.strokeRoundedSettings02),
                onPressed: () => Get.toNamed(Routes.SETTINGS),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.todos.isEmpty) {
              return Center(
                child: ReadyEmptyWidget(
                  customIcon: Image.asset('assets/gifs/no result found.gif'),
                  title: "Add your first task!",
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.todos.length,
              itemBuilder: (context, index) {
                final todo = controller.todos[index];
                return ListTile(
                  title: Text(todo["title"] ?? ""),
                  subtitle: Text(todo["description"] ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.deleteTodo(todo["id"]),
                  ),
                  onTap: () {
                    controller.updateTodo(todo["id"], {
                      ...todo,
                      "isCompleted": !(todo["isCompleted"] ?? false),
                    });
                  },
                );
              },
            );
          }),

          floatingActionButton: _buildFabMenu(),
        );
      },
    );
  }

  /// FAB Menu with two actions
  Widget _buildFabMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🎙 Voice Task FAB
        FloatingActionButton(
          heroTag: "voiceFab",
          mini: true,
          onPressed: () {
            // controller.addVoiceTodo();
          },
          child: const Icon(HugeIcons.strokeRoundedVoice),
        ),
        const SizedBox(height: 12),
        // ➕ Add Task FAB
        FloatingActionButton(
          heroTag: "addTaskFab",
          onPressed: () {
            Get.toNamed(Routes.ADD_TODO);
            // controller.addTask();
          },
          child: const Icon(HugeIcons.strokeRoundedTaskAdd01),
        ),
      ],
    );
  }
}
