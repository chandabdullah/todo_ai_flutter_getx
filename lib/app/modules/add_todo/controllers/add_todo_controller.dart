import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTodoController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final dueDate = Rxn<DateTime>();
  final dueTime = Rxn<TimeOfDay>();
  final priority = "Low".obs;

  bool isListening = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Pick Due Date
  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) dueDate.value = picked;
  }

  /// Pick Due Time
  Future<void> pickDueTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) dueTime.value = picked;
  }

  /// Format Date
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// Format Time
  String formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  /// Save Todo in Firebase
  Future<void> saveTodo() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Title is required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final todo = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "priority": priority.value,
        "dueDate": dueDate.value?.toIso8601String(),
        "dueTime": dueTime.value == null
            ? null
            : "${dueTime.value!.hour}:${dueTime.value!.minute}",
        "createdAt": DateTime.now().toIso8601String(),
        "isCompleted": false,
      };

      await _firestore.collection("todos").add(todo);

      Get.back(); // go back after saving
      Get.snackbar(
        "Success",
        "Task Added!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
