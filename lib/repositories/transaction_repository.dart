import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRepository {
  final _supabase = Supabase.instance.client;

  // 1. Chama a nossa função matemática no Banco (Opção B)
  Future<double> getTotalBalance() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0.0;

    final response = await _supabase.rpc(
      'get_total_balance',
      params: {'p_user_id': userId},
    );

    return (response as num).toDouble();
  }

  // 2. Stream Realtime para a lista de transações da Dashboard
  Stream<List<Map<String, dynamic>>> getTransactionsStream() {
    final userId = _supabase.auth.currentUser?.id;

    return _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId ?? '')
        .order('date', ascending: false)
        .limit(10); // Pegamos apenas as 10 últimas para a Home
  }
}
