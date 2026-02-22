import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finance_pro/core/access_status.dart';
import 'package:finance_pro/controllers/subscription_controller.dart';
//import 'package:finance_pro/controllers/auth_controller.dart';
//import 'package:finance_pro/pages/auth/sign_in_screen.dart';
import 'package:finance_pro/pages/auth/sign_up_screen.dart';
import 'package:finance_pro/pages/auth/waiting_confirmation_page.dart';
import 'package:finance_pro/pages/subscription/subscription_plans_page.dart';
import 'package:finance_pro/pages/dashboard/dashboard_screen.dart';

Future<void> main() async {
  // 1. Garante que os widgets estão inicializados antes do Supabase
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Inicializa o Supabase com o mínimo necessário

  await Supabase.initialize(
    url: 'https://unqtubwlftvplozetphs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVucXR1YndsZnR2cGxvemV0cGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNjM3OTUsImV4cCI6MjA3NTkzOTc5NX0.bRQXGzjGR9knDzEwBQuF0DX7U4Z6t6HJzfqGn0Z6B_4',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Pro',
      theme: ThemeData.dark(), // Estilo RPG
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  final SubscriptionController _subscriptionController =
      SubscriptionController();
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialSession();
  }

  void _checkInitialSession() {
    final user = _supabase.auth.currentUser;
    // Só dispara o controller se o usuário estiver logado e e-mail confirmado
    if (user != null && user.emailConfirmedAt != null) {
      _subscriptionController.refreshAccessStatus(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        debugPrint(
          'DEBUG_AUTH: Event: ${snapshot.data?.event} | Session: ${snapshot.data?.session != null}',
        );

        // TRATAMENTO DE ESTADO VAZIO/CARREGANDO
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;
        final user = session?.user;

        if (session == null) {
          return const SignUpScreen();
        }

        if (user?.emailConfirmedAt == null) {
          return const WaitingConfirmationPage();
        }

        return ListenableBuilder(
          listenable: _subscriptionController,
          builder: (context, _) {
            if (_subscriptionController.status == AccessStatus.loading &&
                user != null) {
              _subscriptionController.refreshAccessStatus(user.id);
            }

            return _navigateBasedOnStatus(_subscriptionController.status);
          },
        );
      },
    );
  }

  Widget _navigateBasedOnStatus(AccessStatus status) {
    switch (status) {
      case AccessStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AccessStatus.trialExpiredNeedsSubscription:
      case AccessStatus.trialExpiredNeedsReferral:
        return const SubscriptionPlansPage();
      case AccessStatus.allowed:
        return const DashboardScreen();
      default:
        return const SignUpScreen();
    }
  }
}
