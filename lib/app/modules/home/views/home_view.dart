import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:intl/intl.dart';
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
              ? Center(
                  child: ReadyEmptyWidget(
                    customIcon: Icon(
                      HugeIcons.strokeRoundedTaskAdd01,
                      size: 100,
                      color: theme.textTheme.bodyLarge?.color?.withAlpha(
                        (0.5 * 255).toInt(),
                      ),
                    ),
                    title: "Add your first task!",
                    additionalWidget: ReadyTextButton(
                      size: ReadyButtonSize.small,
                      text: "Add Task",
                      onPress: () => Get.toNamed(Routes.ADD_TODO),
                      borderColor: theme.textTheme.bodyLarge?.color,
                      icon: HugeIcons.strokeRoundedAdd01,
                      iconPosition: IconPosition.leading,
                      alignment: Alignment.center,
                      width: 120,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.syncWithFirebase();
                  },
                  child: ListView.builder(
                    itemCount: controller.todos.length,
                    itemBuilder: (context, index) {
                      final todo = controller.todos[index];
                      final isCompleted = todo["isCompleted"] ?? false;
                      final dueDate = todo["dueDate"] != null
                          ? DateTime.tryParse(todo["dueDate"].toString())
                          : null;
                      final formattedDate = dueDate != null
                          ? DateFormat("MMM d, yyyy").format(dueDate)
                          : "No Date";

                      final priority = todo["priority"] ?? "Normal";
                      final priorityColor =
                          {
                            "High": Colors.red,
                            "Medium": Colors.orange,
                            "Low": Colors.green,
                          }[priority] ??
                          Colors.grey;

                      return Card(
                        color: isCompleted
                            ? theme.dividerColor.withAlpha((0.1 * 255).toInt())
                            : theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isCompleted
                                ? theme.dividerColor.withAlpha(
                                    (0.1 * 255).toInt(),
                                  )
                                : theme.splashColor,
                            width: 2,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          leading: Checkbox(
                            value: isCompleted,
                            onChanged: (value) {
                              controller.updateTodo(todo["id"], {
                                ...todo,
                                "isCompleted": value ?? false,
                              });
                            },
                          ),
                          title: Text(
                            todo["title"] ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted ? Colors.grey : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (todo["description"] != null &&
                                  todo["description"].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    todo["description"],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isCompleted
                                          ? Colors.grey
                                          : theme.hintColor,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: theme.hintColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Chip(
                                    label: Text(priority),
                                    backgroundColor: priorityColor.withOpacity(
                                      0.1,
                                    ),
                                    labelStyle: TextStyle(
                                      color: priorityColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  HugeIcons.strokeRoundedEdit03,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // TODO: open edit page
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  HugeIcons.strokeRoundedDelete03,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  NAlertDialog(
                                    dialogStyle: DialogStyle(
                                      titleDivider: true,
                                    ),
                                    blur: 2,
                                    title: const Text("Delete Task"),
                                    content: const Text(
                                      "Are you sure you want to delete this task?",
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                        child: const Text("Cancel"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          controller.deleteTodo(todo["id"]);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ).show(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
        FloatingActionButton(
          heroTag: "voiceFab",
          mini: true,
          onPressed: () {
            controller.clearAllTodos();
            // controller.addVoiceTodo();
          },
          child: const Icon(HugeIcons.strokeRoundedVoice),
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
