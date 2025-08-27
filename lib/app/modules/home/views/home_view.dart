import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:todo_ai/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<HomeController>(
      builder: (controller) {
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
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.todos.isEmpty
              ? Center(child: Text("No tasks yet"))
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.syncWithFirebase();
                  },
                  child: ListView(
                    children: [
                      _buildSection(
                        "Today",
                        DateTime.now(),
                        controller.todos,
                        controller,
                        theme,
                      ),
                      _buildSection(
                        "Tomorrow",
                        DateTime.now().add(const Duration(days: 1)),
                        controller.todos,
                        controller,
                        theme,
                      ),
                    ],
                  ),
                ),
          floatingActionButton: _buildFabMenu(controller),
        );
      },
    );
  }

  Widget _buildSection(
    String label,
    DateTime date,
    List<Map<String, dynamic>> todos,
    HomeController controller,
    ThemeData theme,
  ) {
    final sectionTodos =
        todos.where((t) {
          final dueDate = t["dueDate"] != null
              ? DateTime.tryParse(t["dueDate"])
              : null;
          return dueDate != null && dueDate.day == date.day;
        }).toList()..sort((a, b) {
          final aDate = DateTime.tryParse(a["dueDate"] ?? "") ?? DateTime.now();
          final bDate = DateTime.tryParse(b["dueDate"] ?? "") ?? DateTime.now();
          return aDate.compareTo(bDate);
        });

    if (sectionTodos.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat("E dd").format(date), // e.g. Sun 02
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        // Tasks
        ...sectionTodos.map((todo) {
          final isCompleted = todo["isCompleted"] ?? false;
          final dueDate = todo["dueDate"] != null
              ? DateTime.tryParse(todo["dueDate"].toString())
              : null;
          final formattedTime = dueDate != null
              ? DateFormat("HH:mm").format(dueDate)
              : "--:--";

          return Column(
            children: [
              ListTile(
                leading: Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                title: Text(
                  todo["title"] ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : null,
                  ),
                ),
                subtitle:
                    todo["description"] != null &&
                        todo["description"].toString().isNotEmpty
                    ? Text(
                        todo["description"],
                        style: TextStyle(
                          fontSize: 12,
                          color: isCompleted ? Colors.grey : theme.hintColor,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      )
                    : null,
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    controller.updateTodo(todo["id"], {
                      ...todo,
                      "isCompleted": value ?? false,
                    });
                  },
                ),
              ),
              const Divider(indent: 70, thickness: 0.5), // align with text
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFabMenu(HomeController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "voiceFab",
          mini: true,
          onPressed: () {
            // controller.clearAllTodos();
            Get.toNamed(
              Routes.ADD_TODO,
              arguments: {'startListening': true},
            );
          },
          child: const Icon(HugeIcons.strokeRoundedMic01),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "addTaskFab",
          onPressed: () {
            Get.toNamed(Routes.ADD_TODO);
          },
          child: const Icon(HugeIcons.strokeRoundedTaskAdd01),
        ),
      ],
    );
  }
}
