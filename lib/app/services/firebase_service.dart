import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(String id, Map<String, dynamic> todo) async {
    await _firestore.collection("todos").doc(id).set(todo);
  }

  Future<void> updateTodo(String id, Map<String, dynamic> todo) async {
    await _firestore.collection("todos").doc(id).update(todo);
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection("todos").doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final snapshot = await _firestore.collection("todos").get();
    return snapshot.docs.map((doc) {
      return {"id": doc.id, ...doc.data()};
    }).toList();
  }
}
