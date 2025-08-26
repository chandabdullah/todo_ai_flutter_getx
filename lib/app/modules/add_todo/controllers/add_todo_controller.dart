import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_ai/app/services/openai_service.dart';

class AddTodoController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  DateTime? dueDate;
  TimeOfDay? dueTime;
  String priority = "Low";

  List<String> priorities = ["Low", "Medium", "High"];

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
    if (picked != null) dueDate = picked;
  }

  /// Pick Due Time
  Future<void> pickDueTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      dueTime = picked;
      dueDateController.text = formatTime(dueTime ?? TimeOfDay.now());
    }

    update();
  }

  /// Format Date
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// Format Time
  String formatTime(TimeOfDay time, {bool is24HourFormat = false}) {
    if (is24HourFormat) {
      // 24-hour format
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } else {
      // 12-hour format with AM/PM
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? "AM" : "PM";
      return "$hour:$minute $period";
    }
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
      // final ai = OpenAIService();
      // final aiDetails = await ai.generateTodoDetails(
      //   titleController.text.trim(),
      // );

      // print(aiDetails["summary"]);
      // print(aiDetails["category"]);

      // return; // for testing AI only

      final todo = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "priority": priority,
        "dueDate": dueDate?.toIso8601String(),
        "dueTime": dueTime == null ? null : "${dueTime?.hour}:${dueTime?.minute}",
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
