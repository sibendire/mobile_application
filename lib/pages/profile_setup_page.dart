import 'package:flutter/material.dart';
import 'chat_list_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController nameController = TextEditingController();

  void continueToApp() {
    if (nameController.text.isEmpty) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set up profile",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: continueToApp,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}