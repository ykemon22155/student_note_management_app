class NoteBlueprint {
  final String? id;
  final String title;
  final String description;

  // কনস্ট্রাক্টরের নাম ক্লাসের নামের সাথে মিলিয়ে NoteBlueprint করা হলো
  NoteBlueprint({this.id, required this.title, required this.description});

  // ফায়ারস্টোর থেকে ডাটা নেওয়ার জন্য ফ্যাক্টরি মেথড
  factory NoteBlueprint.fromFirestore(Map<String, dynamic> json, String docId) {
    return NoteBlueprint(
      id: docId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // ফায়ারস্টোরে ডাটা পাঠানোর জন্য ম্যাপ তৈরি
  Map<String, dynamic> toFirestoreJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}