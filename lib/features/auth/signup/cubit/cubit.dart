import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(SignupInitial());

  final FirebaseAuth _auth;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      emit(SignupSuccess('Account created successfully.'));
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(e.message ?? 'Sign up failed.'));
    } catch (_) {
      emit(SignupFailure('Sign up failed.'));
    }
  }
}
