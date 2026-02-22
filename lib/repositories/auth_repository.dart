import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Realiza o cadastro de um novo Hunter utilizando E-mail e Senha.
  /// O nome e os atributos serão definidos posteriormente na criação de personagem.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'com.teunome.finance_pro://login-callback',
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocorreu um erro inesperado ao forjar sua conta.';
    }
  }

  /// Realiza o login de veteranos.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Erro ao atravessar o portal: ${e.toString()}';
    }
  }

  /// Realiza o logout do sistema.
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
