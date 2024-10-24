import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/model/task.dart';

class FirebaseService {
  final CollectionReference _taskCollection = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    try {
      await _taskCollection.add(task.toJson());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }
}