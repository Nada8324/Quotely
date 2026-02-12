import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/models/user_model.dart';

import 'states.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
      await _fireStore
          .collection("profiles")
          .doc(credential.user!.uid)
          .set(
            UserModel(
              name: name,
              email: email,
              uid: credential.user!.uid,
            ).toJson(),
          );
      await _auth.signOut();
      emit(SignupSuccess('Account created successfully.'));
    } catch (_) {
      emit(SignupFailure('Sign up failed.'));
    }
  }
}
