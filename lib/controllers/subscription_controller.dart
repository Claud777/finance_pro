import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finance_pro/core/access_status.dart';

class SubscriptionController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  AccessStatus _status = AccessStatus.loading;
  AccessStatus get status => _status;

  /// A lógica central de triagem de acesso
  Future<void> refreshAccessStatus(String userId) async {
    _status = AccessStatus.loading;
    notifyListeners();

    try {
      // 1. Buscar dados detalhados do usuário e contagem de referrals
      // Nota: Usamos o .count() para saber quantos amigos foram convidados
      final userData = await _supabase
          .from('users')
          .select('*, referrals!referrals_referrer_id_fkey(count)')
          .eq('id', userId)
          .single();

      final String subStatus = userData['subscription_status'];
      final DateTime trialEndsAt = DateTime.parse(userData['trial_ends_at']);
      final int referralCount = userData['referrals'][0]['count'] ?? 0;
      final bool isProfileComplete =
          userData['name'] != 'User' && userData['stat_health'] > 0;

      // 2. Hierarquia de Decisão (Gatekeeper)

      // A - Assinatura Ativa
      if (subStatus == 'active') {
        _status = isProfileComplete
            ? AccessStatus.allowed
            : AccessStatus.needsCharacterCreation;
      }
      // B - Pagamento Pendente
      else if (subStatus == 'past_due') {
        _status = AccessStatus.paymentRequired;
      }
      // C - Período de Trial
      else if (subStatus == 'trialing') {
        final bool isTrialValid = DateTime.now().isBefore(trialEndsAt);

        if (isTrialValid) {
          _status = isProfileComplete
              ? AccessStatus.allowed
              : AccessStatus.needsCharacterCreation;
        } else {
          // Trial Expirou: Verificar se já indicou 2 pessoas
          if (referralCount < 2) {
            _status = AccessStatus.trialExpiredNeedsReferral;
          } else {
            _status = AccessStatus.trialExpiredNeedsSubscription;
          }
        }
      } else {
        _status = AccessStatus.trialExpiredNeedsSubscription;
      }
    } catch (e) {
      debugPrint('Erro ao verificar acesso: $e');
      _status =
          AccessStatus.trialExpiredNeedsSubscription; // Fallback de segurança
    }

    notifyListeners();
  }
}
