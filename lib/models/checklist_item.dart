class ChecklistItem {
  final String id;
  final String title;
  bool isDone;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'],
    );
  }
}
