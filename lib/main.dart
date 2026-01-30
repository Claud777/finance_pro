import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finance_pro/pages/login_page.dart';
import 'package:finance_pro/pages/home_page.dart';

Future<void> main() async {
  // 1. Garante que os widgets estão inicializados antes do Supabase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Supabase com o mínimo necessário
  await Supabase.initialize(
    url: 'https://unqtubwlftvplozetphs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVucXR1YndsZnR2cGxvemV0cGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNjM3OTUsImV4cCI6MjA3NTkzOTc5NX0.bRQXGzjGR9knDzEwBQuF0DX7U4Z6t6HJzfqGn0Z6B_4', // Coloca aqui a tua chave completa
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      debugPrint('DEBUG: Evento de Auth -> ${data.event}');
      if (data.session != null) {
        debugPrint('DEBUG: Usuário logado: ${data.session!.user.email}');
      }
    });
    _setupDeepLinkListener();
  }

  void _setupDeepLinkListener() {
    // O Supabase Flutter já tenta capturar o link automaticamente,
    // mas em alguns modelos como o Moto G42, precisamos garantir que o link
    // inicial seja processado se o app for aberto via URL.
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      debugPrint('DEBUG: Sessão inicial detectada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.data?.session;

          if (session != null) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
