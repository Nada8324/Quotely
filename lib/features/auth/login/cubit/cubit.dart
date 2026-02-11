import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(LoginSuccess('Logged in successfully.'));
    } catch (_) {
      emit(LoginFailure('Login failed.'));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(
        PasswordResetEmailSent(
          'A password reset link has been sent to your email. Please check your inbox and spam folder.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        LoginFailure(
          e.message ?? 'An unexpected authentication error occurred.',
        ),
      );
    } catch (e) {
      emit(LoginFailure('Failed to send reset email. Please try again later.'));
    }
  }
}
