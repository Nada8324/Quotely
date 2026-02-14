import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/widgets/show_confirmation_dialog.dart';
import 'package:graduation_project_nti/features/profile/cubit/cubit.dart';
import 'package:graduation_project_nti/features/profile/cubit/states.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final user = cubit.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: AppColors.primaryOrange,
                  
                    child: const Icon(
                            Icons.person,
                            size: 56,
                            color: Colors.white,
                          )
                     
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileSaveSuccess) {
                        setState(() => _isEditing = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }

                      if (state is ProfileSaveFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _isEditing
                                    ? TextFormField(
                                        controller: cubit.nameController,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          final name = value?.trim() ?? '';
                                          if (name.isEmpty) {
                                            return 'Name is required';
                                          }
                                          if (name.length < 2) {
                                            return 'Name must be at least 2 characters';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter your name',
                                          isDense: true,
                                          filled: true,
                                          fillColor: const Color(0xFFF9FAFB),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFE5E7EB),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFE5E7EB),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryOrange,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        cubit.nameController.text.trim().isEmpty
                                            ? '-'
                                            : cubit.nameController.text.trim(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.mail_outline,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  user?.email ?? '-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final isSaving = state is ProfileSaving;

                      return ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () {
                                if (_isEditing) {
                                  cubit.saveName();
                                } else {
                                  setState(() => _isEditing = true);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isEditing ? 'Save Changes' : 'Edit Profile',
                                style: const TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        context: context,
                        title: 'Logout',
                        content: 'Are you sure you want to logout?',
                        confirmText: 'Logout',
                        cancelText: 'Cancel',
                      );

                      if (confirmed) {
                        cubit.logout();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(LucideIcons.logOut, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
