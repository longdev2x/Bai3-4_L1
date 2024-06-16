import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
class TaskEntity {

  final String id;
  final String mainTask;
  final List<String>? additionalTasks;
  final DateTime? date;
  final DateTime? reminderDate;
  final bool? repeat;
  final String? categoryId;

  TaskEntity({
    String? id,
    required this.mainTask,
    this.additionalTasks,
    this.date,
    this.reminderDate,
    this.repeat = false,
    this.categoryId,
  }) : id = id ?? const Uuid().v4();

  TaskEntity copyWith(
          {String? mainTask,
          List<String>? additionalTasks,
          DateTime? date,
          DateTime? reminderDate,
          bool? repeat = false,
          String? categoryId}) =>
      TaskEntity(
        id: id,
        mainTask: mainTask ?? this.mainTask,
        additionalTasks: additionalTasks ?? this.additionalTasks,
        date: date ?? this.date,
        reminderDate: reminderDate ?? this.reminderDate,
        repeat: repeat ?? this.repeat,
        categoryId: categoryId ?? this.categoryId,
      );

  factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
        id: json['id'],
        mainTask: json['main_task'],
        additionalTasks: json['anditional_tasks'],
        date: json['date'] != null ? (json['date'] as Timestamp).toDate() : null,
        reminderDate: json['reminder_date'] != null ? (json['reminder_date'] as Timestamp).toDate() : null,
        repeat: json['repeat'] ?? false
      );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'main_task' : mainTask,
    'anditional_tasks' : additionalTasks,
    'date' : date,
    'reminder_date' : reminderDate,
    'repeat' : repeat,
  };
}
