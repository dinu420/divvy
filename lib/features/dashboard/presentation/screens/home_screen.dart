import 'package:flutter/material.dart';
import 'package:telephony_fix/telephony.dart';

import '../../../../core/services/sms_service.dart';
import '../../../../core/services/sms_parser_service.dart';
import '../../../expenses/data/models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SmsService smsService = SmsService();
  final SmsParserService parserService =
      SmsParserService();

  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
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
        }
      }

      setState(() {
        transactions = parsedTransactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Split"),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(transaction.merchant),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("LKR ${transaction.amount}"),
                  const SizedBox(height: 4),
                  Text(
                    transaction.isProcessed
                        ? "Processed"
                        : "Pending",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}