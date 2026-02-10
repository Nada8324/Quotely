import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: (user?.photoURL?.isNotEmpty ?? false)
                ? NetworkImage(user!.photoURL!)
                : null,
            child: (user?.photoURL?.isEmpty ?? true)
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(height: 16),
          Text('Name: ${user?.displayName ?? '-'}'),
          const SizedBox(height: 8),
          Text('Email: ${user?.email ?? '-'}'),
        ],
      ),
    );
  }
}
