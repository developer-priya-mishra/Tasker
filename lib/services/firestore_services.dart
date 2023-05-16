import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> insertNote({
    required String title,
    required String description,
    required String userId,
  }) async {
    await firestore.collection('notes').add({
      'userId': userId,
      'title': title,
      'description': description,
      'date': Timestamp.now(),
    });
  }

  Future updateNote({
    required String description,
    required String title,
    required String id,
  }) async {
    await firestore.collection('notes').doc(id).update({
      'title': title,
      'description': description,
    });
  }

  Future deleteNote(String id) async {
    await firestore.collection('notes').doc(id).delete();
  }
}
