import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:graduation_project_nti/features/login/cubit/cubit.dart';
import 'package:graduation_project_nti/features/login/cubit/states.dart';
import 'package:graduation_project_nti/features/login/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  //Get.put<FirebaseFirestore>(FirebaseFirestore.instance);
  runApp(const QuotelyApp());
}

class QuotelyApp extends StatelessWidget {
  const QuotelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    return MaterialApp(
      title: 'Quotely',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(create: (context) => LoginCubit(), child:const LoginView()),
    );
  }
}
