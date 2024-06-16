import 'package:uuid/uuid.dart';

class TaskCategoryEntity {
  final String id;
  final String name;

  TaskCategoryEntity({
    String? id,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  TaskCategoryEntity copyWith({String? name}) => TaskCategoryEntity(
        id: id,
        name: name ?? this.name,
      );

  factory TaskCategoryEntity.fromJson(Map<String, dynamic> json) => TaskCategoryEntity(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
