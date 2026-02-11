import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/favorites_remote_ds.dart';

import 'states.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FavoritesRemoteDataSource _remote = FavoritesRemoteDataSource();
  // final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
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
      await _remote.addProfile(
        uid: credential.user!.uid,
        name: name.trim(),
        email: email.trim(),
      );
      await _auth.signOut();
      emit(SignupSuccess('Account created successfully.'));
    } catch (_) {
      emit(SignupFailure('Sign up failed.'));
    }
  }
}
