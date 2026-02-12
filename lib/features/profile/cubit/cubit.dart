import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    nameController.text = user?.displayName ?? '';
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  User? get user => _auth.currentUser;

  Future<void> saveName() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final currentUser = user;
    if (currentUser == null) {
      emit(ProfileSaveFailure('No user found.'));
      return;
    }

    emit(ProfileSaving());

    try {
      await currentUser.updateDisplayName(nameController.text.trim());
      await currentUser.reload();
      emit(ProfileSaveSuccess('Name updated successfully.'));
    } on FirebaseAuthException catch (e) {
      emit(ProfileSaveFailure(e.message ?? 'Unable to update name.'));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
