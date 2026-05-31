import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
    });

    await authService.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      
      codeSent: (verificationId) {
        setState(() {
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!'),
          ),
        );

        context.push('/otp', extra: verificationId,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Smart Split Login"),
    ),
    
    body: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [
          TextField(
            controller: phoneController,

          keyboardType: TextInputType.phone,

          decoration:const InputDecoration(
            labelText: "Phone Number",
            hintText: "+94771234567",
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            onPressed:
            isLoading ? null : sendOTP,

            child: isLoading
              ? const CircularProgressIndicator(
                color: Colors.white,
              )
              : const Text("Send OTP"),
          ),
        ),
      ],
    ),
    ),
    );
  }
}