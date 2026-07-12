import 'package:cloud_firestore/cloud_firestore.dart';
// আপনার কাস্টম নোট মডেল বা ব্লুপ্রিন্ট ফাইলটি এখানে ইম্পোর্ট করা হলো
import 'note_blueprint.dart';

// ক্লাসের নাম পরিবর্তন করে আপনার ফাইলের সাথে মিলিয়ে FirestoreManager দেওয়া হলো
class FirestoreManager {
  // কালেকশনের নাম অ্যাসাইনমেন্ট অনুযায়ী 'notes' রাখা হলো
  final CollectionReference _notesRef =
  FirebaseFirestore.instance.collection('notes');

  // রিয়েলটাইম নোটের লিস্ট রিড করার স্ট্রিম (NoteBlueprint ব্যবহার করে)
  Stream<List<NoteBlueprint>> getNotesStream() {
    return _notesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteBlueprint.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // নতুন নোট তৈরি (Create Note)
  Future<void> addNote(NoteBlueprint note) async {
    await _notesRef.add(note.toFirestoreJson());
  }

  // নোট আপডেট (Update Note)
  Future<void> updateNote(String docId, NoteBlueprint note) async {
    await _notesRef.doc(docId).update(note.toFirestoreJson());
  }

  // নোট ডিলিট (Delete Note)
  Future<void> deleteNote(String docId) async {
    await _notesRef.doc(docId).delete();
  }
}