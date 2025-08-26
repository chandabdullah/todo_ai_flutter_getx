import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:todo_ai/app/data/app_constants.dart';
import 'package:todo_ai/app/services/speech_service.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    );

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
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📝 Title
                ReadyInput(
                  controller: controller.titleController,
                  label: "Task Title",
                  autoFocus: true,
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
                const Gap(20),

                // 📄 Description
                ReadyInput(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  textInputType: TextInputType.multiline,
                  label: "Description",
                  prefixIcon: Icon(HugeIcons.strokeRoundedEdit01),
                ),
                const Gap(20),

                // 📅 Date
                // Obx(
                //   () => ListTile(
                //     contentPadding: EdgeInsets.symmetric(
                //       horizontal: kPadding / 2,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(kBorderRadius),
                //       side: BorderSide(
                //         color:
                //             theme.inputDecorationTheme.outlineBorder?.color ??
                //             Colors.grey,
                //       ),
                //     ),
                //     leading: const Icon(HugeIcons.strokeRoundedCalendar01),
                //     title: Text(
                //       controller.dueDate.value == null
                //           ? "Select Due Date"
                //           : DateFormat(
                //               "MMM dd, yyyy",
                //             ).format(controller.dueDate.value!),
                //     ),
                //     trailing: const Icon(
                //       HugeIcons.strokeRoundedArrowRight01,
                //       size: 20,
                //     ),
                //     onTap: () => controller.pickDueDate(),
                //   ),
                // ),
                ReadyInput(
                  readOnly: true,
                  onTap: () => controller.pickDueDate(),
                  label: "Due Date",
                  prefixIcon: Icon(HugeIcons.strokeRoundedCalendar01),
                  hint: "Select Due Date",
                  controller: TextEditingController(
                    text: controller.dueDate == null
                        ? ""
                        : DateFormat(
                            "MMM dd, yyyy",
                          ).format(controller.dueDate!),
                  ),
                ),
                const Gap(20),

                // ⏰ Time
                // Obx(
                //   () => ListTile(
                //     contentPadding: EdgeInsets.zero,
                //     leading: const Icon(HugeIcons.strokeRoundedClock01),
                //     title: Text(
                //       controller.dueTime == null
                //           ? "Select Time"
                //           : controller.formatTime(controller.dueTime),
                //     ),
                //     trailing: const Icon(
                //       HugeIcons.strokeRoundedArrowRight01,
                //       size: 20,
                //     ),
                //     onTap: () => controller.pickDueTime(),
                //   ),
                // ),
                ReadyInput(
                  readOnly: true,
                  onTap: () => controller.pickDueTime(),
                  label: "Due Time",
                  prefixIcon: Icon(HugeIcons.strokeRoundedClock01),
                  hint: "Select Due Time",
                  controller: controller.dueDateController,
                ),
                const Gap(20),

                // ⚡ Priority Dropdown
                DropdownButtonFormField<String>(
                  value: controller.priority,
                  selectedItemBuilder: (context) {
                    return controller.priorities.map((p) => Text(p)).toList();
                  },

                  items: controller.priorities
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Row(
                            children: [
                              Icon(
                                HugeIcons.strokeRoundedFlag01,
                                color: p == 'Low'
                                    ? Colors.green
                                    : p == 'Medium'
                                    ? Colors.amber
                                    : Colors.red,
                              ),
                              Gap(kSpacing),
                              Text(p),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    controller.priority = val ?? "Low";
                    controller.update();
                  },
                  decoration: InputDecoration(
                    labelText: "Priority",
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedFlag01,
                      color: controller.priority == 'Low'
                          ? Colors.green
                          : controller.priority == 'Medium'
                          ? Colors.amber
                          : Colors.red,
                    ),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: focusedBorder,
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
