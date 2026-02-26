import 'package:flutter/material.dart';
import 'otp_page.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({super.key});

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void sendCode() async {
    if (phoneController.text.length < 9) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // Fake API call

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpPage(phone: phoneController.text),
      ),
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
              "Welcome",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Enter your phone number to continue"),
            const SizedBox(height: 40),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: "+256 ",
                labelText: "Phone Number",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : sendCode,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send Code"),
            ),
          ],
        ),
      ),
    );
  }
}