import 'package:flutter/material.dart';

class SubscriptionPlansPage extends StatelessWidget {
  const SubscriptionPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planos de Assinatura')),
      body: const Center(
        child: Text('Escolha seu plano: Mensal, Semestral ou Anual.'),
      ),
    );
  }
}
