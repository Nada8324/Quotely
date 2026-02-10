import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/features/auth/login/cubit/cubit.dart';
import 'package:graduation_project_nti/features/auth/login/login_view.dart';
import 'package:graduation_project_nti/features/auth/profile/view/profile_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != null) {
          return const ProfileView();
        }

        return BlocProvider(
          create: (_) => LoginCubit(),
          child: const LoginView(),
        );
      },
    );
  }
}
