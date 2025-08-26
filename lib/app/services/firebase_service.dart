import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference todosRef = FirebaseFirestore.instance.collection(
    'todos',
  );

  Future<void> addTodo(String id, Map<String, dynamic> todo) async {
    await todosRef.doc(id).set(todo); // ✅ overwrite instead of duplicate
  }

  Future<void> updateTodo(String id, Map<String, dynamic> todo) async {
    await todosRef.doc(id).update(todo);
  }

  Future<void> deleteTodo(String id) async {
    await todosRef.doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final snapshot = await todosRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data["id"] = doc.id; // ensure ID is included
      return data;
    }).toList();
  }
}
