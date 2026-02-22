import 'package:flutter/material.dart';

class TrialExpiredReferralPage extends StatelessWidget {
  const TrialExpiredReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trial Expirado')),
      body: const Center(
        child: Text('Convide 2 amigos para continuar sua jornada!'),
      ),
    );
  }
}
