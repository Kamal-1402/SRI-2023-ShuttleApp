// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:learn_flutter/firebase_options.dart';
// import 'package:learn_flutter/views/RegisterPage.dart';
// import 'package:learn_flutter/views/loginPage.dart';


class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verify'),
      ),
      body: Column(
        children: [
          const Text("Please Verify Your Email"),
          ElevatedButton(
            onPressed: () async {
              final CurrUser = FirebaseAuth.instance.currentUser;
              await CurrUser?.sendEmailVerification();
            },
            child: const Text("Send Email"),
          ),
          ElevatedButton(
            onPressed: () async {
              final CurrUser = FirebaseAuth.instance.currentUser;
              await CurrUser?.reload();
              if (CurrUser?.emailVerified ?? false) {
                print("you are verified");
              } else {
                print("you are not verified");
              }
            },
            child: const Text("Reload"),
          ),
        ],
      ),
    );
  }
}