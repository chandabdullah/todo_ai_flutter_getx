import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:todo_ai/app/services/speech_service.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AddTodoController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Task"),
            actions: [
              IconButton(
                icon: const Icon(HugeIcons.strokeRoundedCheckmarkSquare04),
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
                ReadyInput(
                  controller: controller.titleController,
                  label: "Task Title",
                  prefixIcon: Icon(HugeIcons.strokeRoundedTask01),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      print(
                        "controller.isListening: ${controller.isListening}",
                      );
                      if (!controller.isListening) {
                        await SpeechService().initSpeech();
                        SpeechService().startListening((text) {
                          final currentText = controller.titleController.text;
                          controller.titleController.text = currentText.isEmpty
                              ? text
                              : "$currentText $text";
                        });
                        controller.isListening = true;
                        controller.update();
                      } else {
                        SpeechService().stopListening();
                        controller.isListening = false;
                        controller.update();
                      }
                    },
                    icon: Icon(
                      !controller.isListening
                          ? HugeIcons.strokeRoundedMic01
                          : HugeIcons.strokeRoundedStop,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 📄 Description
                ReadyInput(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  textInputType: TextInputType.multiline,
                  label: "Description",
                  prefixIcon: Icon(HugeIcons.strokeRoundedEdit01),
                ),
                const SizedBox(height: 16),

                // 📅 Date
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(HugeIcons.strokeRoundedCalendar01),
                    title: Text(
                      controller.dueDate.value == null
                          ? "Select Due Date"
                          : DateFormat(
                              "MMM dd, yyyy",
                            ).format(controller.dueDate.value!),
                    ),
                    trailing: const Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      size: 16,
                    ),
                    onTap: () => controller.pickDueDate(),
                  ),
                ),
                const SizedBox(height: 16),

                // ⏰ Time
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(HugeIcons.strokeRoundedClock01),
                    title: Text(
                      controller.dueTime.value == null
                          ? "Select Time"
                          : controller.formatTime(controller.dueTime.value!),
                    ),
                    trailing: const Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      size: 16,
                    ),
                    onTap: () => controller.pickDueTime(),
                  ),
                ),
                const SizedBox(height: 16),

                // ⚡ Priority Dropdown
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.priority.value,
                    items: ["Low", "Medium", "High"]
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) =>
                        controller.priority.value = val ?? "Low",
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      prefixIcon: Icon(HugeIcons.strokeRoundedFlag01),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
