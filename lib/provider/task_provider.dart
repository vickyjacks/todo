import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../model/task.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;


  //! time of date
  String timeOfDay = '';
  void updateTimeOfDay() {
    final currentTime = DateTime.now();
    if (currentTime.hour >= 0 && currentTime.hour < 6) {
      timeOfDay = 'Night';
    } else if (currentTime.hour >= 6 && currentTime.hour < 12) {
      timeOfDay = 'Morning';
    } else if (currentTime.hour >= 12 && currentTime.hour < 16) {
      timeOfDay = 'Afternoon';
    } else {
      timeOfDay = 'Evening';
    }
  }


  int get tasksCount => _tasks.length;
  Future<void> addTask(Task task) async {

    await DatabaseHelper().insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper().updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  // Future<void> deleteTask(Task task) async {
  //   await DatabaseHelper().deleteTask(task.id);
  //   _tasks.removeWhere((t) => t.id == task.id);
  //   notifyListeners();
  // }
  Future<void> deleteTask(Task task) async {
    await DatabaseHelper().deleteTask(task.id);
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final tasks = await DatabaseHelper().getTasks();
    _tasks = tasks;
    notifyListeners();
  }
}