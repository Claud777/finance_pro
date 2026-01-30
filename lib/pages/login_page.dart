import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  Future<void> _signIn() async {
    try {
  await Supabase.instance.client.auth.signInWithOtp(
    email: _emailController.text.trim(),
    emailRedirectTo: 'io.supabase.flutter://login-callback/',
  );
} on AuthException catch (error) {
  // Captura especificamente erros de autenticação e limites
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.message), backgroundColor: Colors.red),
  );
} catch (error) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Erro inesperado. Tente novamente em 1 hora.'), backgroundColor: Colors.orange),
  );
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar no Finance Pro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Seu E-mail'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signIn, child: const Text('Enviar Link de Login')),
          ],
        ),
      ),
    );
  }
}