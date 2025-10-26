class Program {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String level;
  final List<String> learning;
  final List<Module> modules;

  const Program({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.learning,
    required this.modules,
  });

  // Factory constructor to create Program from JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      learning: json['learning'] != null
          ? List<String>.from(json['learning'].map((x) => x.toString()))
          : [],
      modules: json['modules'] != null
          ? List<Module>.from(json['modules'].map((x) => Module.fromJson(x)))
          : [],
    );
  }

  // Convert Program to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'level': level,
      'learning': learning,
      'modules': modules.map((x) => x.toJson()).toList(),
    };
  }

  // Create a copy with some fields updated
  Program copyWith({
    String? id,
    String? title,
    String? description,
    String? duration,
    String? level,
    List<String>? learning,
    List<Module>? modules,
  }) {
    return Program(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      learning: learning ?? this.learning,
      modules: modules ?? this.modules,
    );
  }

  // Helper method to get total tasks count
  int get totalTasks {
    return modules.fold(0, (sum, module) => sum + module.tasks.length);
  }

  // Helper method to get level color
  ProgramLevel get levelEnum {
    switch (level.toLowerCase()) {
      case 'beginner':
        return ProgramLevel.beginner;
      case 'intermediate':
        return ProgramLevel.intermediate;
      case 'advanced':
        return ProgramLevel.advanced;
      default:
        return ProgramLevel.intermediate;
    }
  }

  @override
  String toString() {
    return 'Program(id: $id, title: $title, level: $level, modules: ${modules.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Program && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Module {
  final String week;
  final String title;
  final List<Task> tasks;

  const Module({required this.week, required this.title, required this.tasks});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      week: json['week']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      tasks: json['tasks'] != null
          ? List<Task>.from(json['tasks'].map((x) => Task.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'title': title,
      'tasks': tasks.map((x) => x.toJson()).toList(),
    };
  }

  Module copyWith({String? week, String? title, List<Task>? tasks}) {
    return Module(
      week: week ?? this.week,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() {
    return 'Module(week: $week, title: $title, tasks: ${tasks.length})';
  }
}

class Task {
  final String name;
  final TaskType type;

  const Task({required this.name, required this.type});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name']?.toString() ?? '',
      type: TaskType.fromString(json['type']?.toString() ?? 'reading'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type.value};
  }

  Task copyWith({String? name, TaskType? type}) {
    return Task(name: name ?? this.name, type: type ?? this.type);
  }

  @override
  String toString() {
    return 'Task(name: $name, type: ${type.value})';
  }
}

// Enums for better type safety
enum TaskType {
  reading('reading'),
  quiz('quiz'),
  project('project');

  const TaskType(this.value);
  final String value;

  static TaskType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'reading':
        return TaskType.reading;
      case 'quiz':
        return TaskType.quiz;
      case 'project':
        return TaskType.project;
      default:
        return TaskType.reading;
    }
  }
}

enum ProgramLevel {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const ProgramLevel(this.displayName);
  final String displayName;

  static ProgramLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'beginner':
        return ProgramLevel.beginner;
      case 'intermediate':
        return ProgramLevel.intermediate;
      case 'advanced':
        return ProgramLevel.advanced;
      default:
        return ProgramLevel.intermediate;
    }
  }
}
