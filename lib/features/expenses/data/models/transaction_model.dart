class TransactionModel {
  final String merchant;
  final double amount;
  final String rawMessage;
  final bool isSplit;
  final bool isProcessed;
  final DateTime createdAt;

  TransactionModel({
    required this.merchant,
    required this.amount,
    required this.rawMessage,
    this.isSplit = false,
    this.isProcessed = false,
    required this.createdAt,
  });
}