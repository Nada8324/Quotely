import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(LoginInitial());

  final FirebaseAuth _auth;

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(LoginSuccess('Logged in successfully.'));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Login failed.'));
    } catch (_) {
      emit(LoginFailure('Login failed.'));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(LoginLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(LoginSuccess('Password reset email sent.'));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Could not send reset email.'));
    } catch (_) {
      emit(LoginFailure('Could not send reset email.'));
    }
  }
}
