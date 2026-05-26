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

  Map<String, dynamic> toMap() {
    return {
      'merchant': merchant,
      'amount': amount,
      'rawMessage': rawMessage,
      'isSplit': isSplit,
      'isProcessed': isProcessed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}