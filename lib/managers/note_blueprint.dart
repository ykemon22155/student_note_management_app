class NoteBlueprint {
  final String? id;
  final String title;
  final String description;

  NoteBlueprint({this.id, required this.title, required this.description});

  factory NoteBlueprint.fromFirestore(Map<String, dynamic> json, String docId) {
    return NoteBlueprint(
      id: docId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}