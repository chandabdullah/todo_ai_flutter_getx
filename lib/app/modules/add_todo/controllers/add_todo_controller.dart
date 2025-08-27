import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class AddTodoController extends GetxController {
  /// --------- Controllers ----------
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController =
      TextEditingController(); // shows picked time in text

  /// --------- State ----------
  DateTime? dueDate;
  TimeOfDay? dueTime;
  String priority = "Medium";
  List<String> priorities = ["Low", "Medium", "High"];

  bool isListening = false;
  bool _autoStart = false;

  /// --------- Firestore ----------
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --------- Speech ----------
  final SpeechToText speech = SpeechToText();
  bool speechReady = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['startListening'] == true) {
      _autoStart = true;
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (_autoStart && !isListening) {
      startListening(); // <- your existing method
    }
  }

  Future<bool> _initSpeech() async {
    if (speechReady) return true;
    speechReady = await speech.initialize(
      onStatus: (status) {
        // Called when user stops from OS mic UI or after silence timeout.
        // Values commonly: 'listening' | 'notListening'
        if (status == 'notListening' && isListening) {
          stopListening(); // <-- ensure flags/UI are reset
        }
      },
      onError: (e) {
        isListening = false;
        update();
        Get.snackbar(
          "Speech Error",
          e.errorMsg,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
    return speechReady;
  }

  Future<void> toggleMic() async {
    if (isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    final ok = await _initSpeech();
    if (!ok) {
      Get.snackbar(
        "Speech",
        "Speech recognition not available",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (isListening) return;

    isListening = true;
    update();

    await speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation, // continuous dictation mode
        partialResults: true,
        cancelOnError: true,
      ),
      localeId: 'en_US',
      // Stop automatically after 2s of silence, or after 1 min total
      pauseFor: const Duration(seconds: 2),
      listenFor: const Duration(minutes: 1),

      onResult: (SpeechRecognitionResult r) {
        final text = r.recognizedWords;
        // Live update
        titleController.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
        update();

        // If the engine considers this final, stop.
        if (r.finalResult) {
          stopListening();
        }
      },
      // Optional: stop on very low sound for a while (extra safety)
      onSoundLevelChange: (level) {
        // you can add heuristics here if you want
      },
    );
  }

  Future<void> stopListening() async {
    await speech.stop();
    if (!isListening) return;
    isListening = false;
    update();
  }

  /// --------- Date / Time Pickers ----------
  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dueDate = picked;
      update();
    }
  }

  Future<void> pickDueTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      dueTime = picked;
      dueDateController.text = formatTime(dueTime!);
      update();
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String formatTime(TimeOfDay time, {bool is24HourFormat = true}) {
    if (is24HourFormat) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? "AM" : "PM";
      return "$hour:$minute $period";
    }
  }

  /// --------- Save ----------
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
        "priority": priority,
        "dueDate": dueDate?.toIso8601String(),
        "dueTime": dueTime == null
            ? null
            : "${dueTime?.hour}:${dueTime?.minute}",
        "createdAt": DateTime.now().toIso8601String(),
        "isCompleted": false,
      };

      await _firestore.collection("todos").add(todo);

      Get.back();
      Get.snackbar(
        "Success",
        "Task Added!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    speech.stop();
    super.onClose();
  }
}
