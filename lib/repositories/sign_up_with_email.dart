import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NOVO RECRUTA')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Área de Alistamento (Sign Up)',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Chamar AuthController.signUp
              },
              child: const Text('CADASTRAR'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar para SignInPage
              },
              child: const Text('Já sou um Hunter (Login)'),
            ),
          ],
        ),
      ),
    );
  }
}
