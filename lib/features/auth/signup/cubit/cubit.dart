import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _auth.signOut();
      emit(SignupSuccess('Account created successfully.'));
    } catch (_) {
      emit(SignupFailure('Sign up failed.'));
    }
  }
}
