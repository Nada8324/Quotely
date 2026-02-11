import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graduation_project_nti/features/auth/auth_gate.dart';
import 'package:graduation_project_nti/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Load environment values first (if needed by future features/services).
  await dotenv.load(fileName: '.env');

  // Initialize Firebase once at app startup.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const QuotelyApp());
}

class QuotelyApp extends StatelessWidget {
  const QuotelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotely',
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
