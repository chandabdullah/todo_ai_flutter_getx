import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        actions: [
          IconButton(
            icon: const Icon(HugeIcons.strokeRoundedCheckmarkCircle01),
            onPressed: () => controller.saveTodo(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Title
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: "Task Title",
                prefixIcon: Icon(HugeIcons.strokeRoundedTask01),
              ),
            ),
            const SizedBox(height: 16),

            // 📄 Description
            TextField(
              controller: controller.descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(HugeIcons.strokeRoundedEdit01),
              ),
            ),
            const SizedBox(height: 16),

            // 📅 Date
            Obx(() => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(HugeIcons.strokeRoundedCalendar01),
                  title: Text(controller.dueDate.value == null
                      ? "Select Due Date"
                      : controller.formatDate(controller.dueDate.value!)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => controller.pickDueDate(),
                )),
            const SizedBox(height: 16),

            // ⏰ Time
            Obx(() => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(HugeIcons.strokeRoundedClock01),
                  title: Text(controller.dueTime.value == null
                      ? "Select Time"
                      : controller.formatTime(controller.dueTime.value!)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => controller.pickDueTime(),
                )),
            const SizedBox(height: 16),

            // ⚡ Priority Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.priority.value,
                  items: ["Low", "Medium", "High"]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          ))
                      .toList(),
                  onChanged: (val) => controller.priority.value = val ?? "Low",
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    prefixIcon: Icon(HugeIcons.strokeRoundedFlag01),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
