class Task {
  String id;
  String description;
  bool isDone;

  Task({
    required this.id,
    required this.description,
    this.isDone = false,
  });
}
