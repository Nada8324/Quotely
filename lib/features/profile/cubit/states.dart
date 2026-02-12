sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSaving extends ProfileState {}

class ProfileSaveSuccess extends ProfileState {
  final String message;
  ProfileSaveSuccess(this.message);
}

class ProfileSaveFailure extends ProfileState {
  final String message;
  ProfileSaveFailure(this.message);
}
