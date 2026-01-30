class TransactionModel {
  final String id;
  final String userId;
  final String accountId;
  final String? categoryId;
  final String type; // 'expense', 'income', 'transfer'
  final double amount;
  final String currency;
  final DateTime date;
  final String description;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    required this.description,
  });

  // Converte o mapa que vem do Supabase para o nosso objeto Dart
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      accountId: map['account_id'],
      categoryId: map['category_id'],
      type: map['type'],
      // O numeric do Postgres pode vir como int ou double, o .toDouble() previne erros
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] ?? 'BRL',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
    );
  }

  // Útil se precisarmos enviar dados de volta para o banco futuramente
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'account_id': accountId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
