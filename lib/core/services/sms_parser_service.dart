import '../../features/expenses/data/models/transaction_model.dart';

class SmsParserService {
  TransactionModel? parserTransaction(String sms) {
    final lowerSms = sms.toLowerCase();

    if (!lowerSms.contains("spent") &&
        !lowerSms.contains("purchase") &&
        !lowerSms.contains("transaction")) {
      return null;
        }

  final amountRegex =
      RegExp(r'(LKR|Rs\.?)\s?([\d,]+)');

  final amountMatch = amountRegex.firstMatch(sms);

  if (amountMatch == null) return null;

  final amountString =
      amountMatch.group(2)?.replaceAll(',', '') ?? '0';

  final amount = double.tryParse(amountString) ?? 0;

  String merchant = "Unknown";

  if(lowerSms.contains("at")) {
    final parts = sms.split("at");

    if (parts.length > 1) {
      merchant = parts[1].trim();
    }
  }

  return TransactionModel(
    merchant: merchant,
    amount: amount,
    rawMessage: sms,
    createdAt: DateTime.now(),
    );
  }
}