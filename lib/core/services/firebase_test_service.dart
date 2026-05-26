import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendTestData() async {
    await _firestore.collection("test").add({
      "message": "Smart Split is connected",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTestData() {
    return _firestore
        .collection("test")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}