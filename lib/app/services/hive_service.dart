import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _todoBoxName = "todos";

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox<Map>(_todoBoxName);
  }

  Box<Map> get _todoBox => Hive.box<Map>(_todoBoxName);

  /// Save a todo locally (default `synced: false`)
  Future<void> saveTodoLocal(Map<String, dynamic> todo) async {
    final id = todo['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    todo['id'] = id;
    todo['synced'] = todo['synced'] ?? false;

    await _todoBox.put(id, Map<String, dynamic>.from(todo));
  }

  /// Get all todos
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    return _todoBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Update todo
  Future<void> updateTodo(String id, Map<String, dynamic> todo) async {
    if (_todoBox.containsKey(id)) {
      await _todoBox.put(id, Map<String, dynamic>.from(todo));
    }
  }

  /// Delete todo
  Future<void> deleteTodo(String id) async {
    print('--id: $id');
    await _todoBox.delete(id);
  }

  /// Mark todo as synced (important for sync service)
  Future<void> markAsSynced(String id) async {
    final todo = _todoBox.get(id);
    if (todo != null) {
      final updatedTodo = Map<String, dynamic>.from(todo);
      updatedTodo['synced'] = true;
      await _todoBox.put(id, updatedTodo);
    }
  }

  /// Clear all todos (optional utility)
  Future<void> clearAll() async {
    await _todoBox.clear();
  }
}
