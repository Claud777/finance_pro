import 'package:flutter/material.dart';
import '../repositories/transaction_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionRepository _repository = TransactionRepository();
  int _selectedIndex = 2; // Começa na "Nova Transação" ou "Home"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Cinza claro de fundo
      appBar: AppBar(
        title: const Text('Finance Pro', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: SALDO LÍQUIDO ---
            const Text(
              'Saldo Líquido Total',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 5),
            FutureBuilder<double>(
              future: _repository.getTotalBalance(),
              builder: (context, snapshot) {
                final balance = snapshot.data ?? 0.0;
                return Text(
                  'R\$ ${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // --- SUB-HEADER: GASTOS DO MÊS ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Gastos do mês: R\$ 1.250,00', // Valor estático por enquanto
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- ESPAÇO PARA O GRÁFICO ---
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Center(child: Text("Gráfico de Entradas/Saídas")),
            ),

            const SizedBox(height: 20),

            // --- BOTÃO DETALHADO (ROLANDO A TELA) ---
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.credit_card),
              label: const Text("Ver gastos por cartão/conta"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),

      // --- BARRA DE NAVEGAÇÃO CUSTOMIZADA ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Invest.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cartões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'Nova',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Orçam.'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Plan.'),
        ],
      ),
    );
  }
}
