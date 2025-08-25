import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../services/firebase_service.dart';
import '../../../services/hive_service.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();
  final HiveService _hiveService = HiveService();

  final todos = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await _hiveService.init();
    loadTodos();
    // syncWithFirebase();
  }

  /// Load from Hive always (single source of truth)
  Future<void> loadTodos() async {
    isLoading = true;
    update();
    todos.value = await _hiveService.getAllTodos();
    isLoading = false;
    update();
  }

  /// Add new todo
  Future<void> addTodo(Map<String, dynamic> todo) async {
    final id = const Uuid().v4();
    todo["id"] = id;
    todo["synced"] = false;

    // save locally first
    await _hiveService.saveTodoLocal(todo);
    await loadTodos();

    // try syncing if online
    if (await _isOnline()) {
      await _firebaseService.addTodo(id, todo);
      await _hiveService.markAsSynced(id);
      await loadTodos();
    }
  }

  /// Update todo
  Future<void> updateTodo(String id, Map<String, dynamic> todo) async {
    todo["synced"] = false;

    await _hiveService.updateTodo(id, todo);
    await loadTodos();

    if (await _isOnline()) {
      await _firebaseService.updateTodo(id, todo);
      await _hiveService.markAsSynced(id);
      await loadTodos();
    }
  }

  /// Delete todo
  Future<void> deleteTodo(String id) async {
    await _hiveService.deleteTodo(id);
    await loadTodos();

    if (await _isOnline()) {
      await _firebaseService.deleteTodo(id);
    }
  }

  /// Sync local unsynced → Firebase, then pull Firebase copy → Hive
  Future<void> syncWithFirebase() async {
    if (await _isOnline()) {
      // 1) Push local unsynced todos to Firebase
      final localTodos = await _hiveService.getAllTodos();
      for (var todo in localTodos) {
        if (todo["synced"] == false) {
          await _firebaseService.addTodo(todo["id"], todo);
          await _hiveService.markAsSynced(todo["id"]);
        }
      }

      // 2) Pull latest Firebase todos
      final firebaseTodos = await _firebaseService.fetchTodos();

      // replace Hive with Firebase copy
      await _hiveService.clearAll();
      for (var todo in firebaseTodos) {
        await _hiveService.saveTodoLocal(todo);
      }

      await loadTodos();
    }
  }

  Future<bool> _isOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }
}
