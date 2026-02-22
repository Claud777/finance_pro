import 'package:flutter/material.dart';

class WaitingConfirmationPage extends StatelessWidget {
  const WaitingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'VALIDAÇÃO NECESSÁRIA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enviamos uma mensagem de confirmação para o seu e-mail. Por favor, confirme para se cadastrar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Lógica para reenviar e-mail
                },
                child: const Text('REENVIAR E-MAIL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
