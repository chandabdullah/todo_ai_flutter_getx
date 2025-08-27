import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:todo_ai/app/data/app_constants.dart';
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
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    );

    return GetBuilder<AddTodoController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Task"),
            actions: [
              IconButton(
                icon: const Icon(HugeIcons.strokeRoundedCheckmarkSquare04),
                onPressed: controller.saveTodo,
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
                  readOnly:
                      controller.isListening, // prevent typing while listening
                  autoFocus: true,
                  prefixIcon: controller.isListening
                      ? const Icon(
                          HugeIcons.strokeRoundedEar,
                          // color: Colors.red,
                        )
                      : const Icon(HugeIcons.strokeRoundedTask01),
                  hint: controller.isListening ? "Listening..." : null,
                  suffixIcon: IconButton(
                    onPressed: controller.toggleMic,
                    icon: Icon(
                      controller.isListening
                          ? HugeIcons
                                .strokeRoundedMic01 // show mic icon when listening
                          : HugeIcons
                                .strokeRoundedMic01, // show mic-off when not listening
                      color: controller.isListening ? Colors.red : Colors.grey,
                    ),
                  ),

                  // Tap anywhere on suffix to toggle mic
                  // onTapSuffix: controller.toggleMic,
                ),

                // if (controller.isListening) ...[
                //   const Gap(8),
                //   Row(
                //     children: [
                //       const Icon(Icons.hearing, color: Colors.red),
                //       const SizedBox(width: 6),
                //       Text(
                //         "Listening...",
                //         style: TextStyle(
                //           color: Colors.red.shade700,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ],
                const Gap(20),

                // 📄 Description
                ReadyInput(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  textInputType: TextInputType.multiline,
                  label: "Description",
                  prefixIcon: const Icon(HugeIcons.strokeRoundedEdit01),
                ),
                const Gap(20),

                // 📅 Date
                ReadyInput(
                  readOnly: true,
                  onTap: controller.pickDueDate,
                  label: "Due Date",
                  prefixIcon: const Icon(HugeIcons.strokeRoundedCalendar01),
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
                ReadyInput(
                  readOnly: true,
                  onTap: controller.pickDueTime,
                  label: "Due Time",
                  prefixIcon: const Icon(HugeIcons.strokeRoundedClock01),
                  hint: "Select Due Time",
                  controller: controller.dueDateController,
                ),
                const Gap(20),

                // ⚡ Priority Dropdown
                DropdownButtonFormField<String>(
                  value: controller.priority,
                  selectedItemBuilder: (context) =>
                      controller.priorities.map((p) => Text(p)).toList(),
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
                              const Gap(kSpacing),
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
