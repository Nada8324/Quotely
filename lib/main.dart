import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_nti/features/auth/auth_gate.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
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
