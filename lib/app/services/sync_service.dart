import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'firebase_service.dart';
import 'hive_service.dart';

class SyncService extends GetxService {
  final FirebaseService _firebaseService = FirebaseService();
  final HiveService _hiveService = HiveService();

  StreamSubscription? _connectivitySubscription;

  Future<SyncService> init() async {
    // Start listening to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) async {
      if (result != ConnectivityResult.none) {
        await syncTodos();
      }
    });
    return this;
  }

  /// Sync local Hive todos to Firebase when online
  Future<void> syncTodos() async {
    try {
      final localTodos = await _hiveService.getAllTodos();

      for (var todo in localTodos) {
        // If not synced yet, push to Firebase
        if (todo['synced'] == false) {
          final id = const Uuid().v4();
          todo["id"] = id;
          await _firebaseService.addTodo(id, todo);
          await _hiveService.markAsSynced(todo['id']);
        }
      }
    } catch (e) {
      print("Sync error: $e");
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
