import 'package:flutter/material.dart';
import 'package:telephony_fix/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/sms_service.dart';
import '../../../../core/services/sms_parser_service.dart';
import '../../../expenses/data/models/transaction_model.dart';
import '../../../../core/services/firebase_test_service.dart';
import '../../../expenses/data/services/transaction_firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SmsService smsService = SmsService();
  final SmsParserService parserService =
      SmsParserService();

  final FirebaseTestService firebaseTestService = FirebaseTestService();
  final TransactionFirestoreService firestoreService = TransactionFirestoreService();
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
    sendTest();
  }

  Future<void> loadMessages() async {
    bool? permissionGranted =
        await smsService.requestPermission();

    if (permissionGranted == true) {
      List<SmsMessage> smsList =
          await smsService.getInboxMessages();

      List<TransactionModel> parsedTransactions = [];

      for (var sms in smsList) {
        final body = sms.body ?? '';

        final parsed =
            parserService.parserTransaction(body);

        if (parsed != null) {
          parsedTransactions.add(parsed);

          await firestoreService.saveTransaction(parsed);
        }
      }

      setState(() {
        transactions = parsedTransactions;
      });
    }
  }

  void showSplitDialog(int index) {
    showDialog(
      context: context,
       builder: (context) {
        return AlertDialog(
          title: const Text("Split Expense"),
          content: const Text(
            "Do you want split this expense?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                splitExpense(index);
                Navigator.pop(context);
              },
              child: const Text("Split"),
            ),
          ],
        );
       },
      );
  }

  void splitExpense(int index) {
    final oldTransaction = transactions[index];

    final updatedTransaction = TransactionModel(
      merchant: oldTransaction.merchant,
      amount: oldTransaction.amount,
      rawMessage: oldTransaction.rawMessage,
      createdAt: oldTransaction.createdAt,
      isSplit: true,
      isProcessed: true,
    );

    setState(() {
      transactions[index] = updatedTransaction;
    });
  }

  void sendTest() {
    firebaseTestService.sendTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Split"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data found"));
          }
          
          final docs = snapshot.data!.docs;

          return ListView.builder(
             itemCount: docs.length,
             itemBuilder: (context, index) {
              final data = 
                  docs[index].data() as Map<String, dynamic>;

          
          return ListTile(
            title: Text(data["message"] ?? ""),
            subtitle: Text(
              data["timestamp"]?.toString() ?? "",
            ),
          );
        }, 
      );
    },
  ),
);
}
}