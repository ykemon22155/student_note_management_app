import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_blueprint.dart';
class FirestoreManager {
  final CollectionReference _notesRef =
  FirebaseFirestore.instance.collection('notes');

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

  Future<void> addNote(NoteBlueprint note) async {
    await _notesRef.add(note.toFirestoreJson());
  }
  Future<void> updateNote(String docId, NoteBlueprint note) async {
    await _notesRef.doc(docId).update(note.toFirestoreJson());
  }
  Future<void> deleteNote(String docId) async {
    await _notesRef.doc(docId).delete();
  }
}