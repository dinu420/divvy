import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class TransactionFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTransaction(
    TransactionModel transaction) async {
      await _firestore.collection('transactions').add(transaction.toMap());
    }

    Stream<QuerySnapshot> getTransactions() {
      return _firestore.collection('transactions').snapshots();
    }
  
}