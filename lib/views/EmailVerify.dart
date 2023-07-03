// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev show log;
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email Verify'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Please Verify Your Email",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final CurrUser = FirebaseAuth.instance.currentUser;
                    await CurrUser?.sendEmailVerification();
                    dev.log("Email Sent");
                  },
                  child: const Text(
                    "Send Email",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    final CurrUser = FirebaseAuth.instance.currentUser;
                    await CurrUser?.reload();
                    if (CurrUser?.emailVerified ?? false) {
                      dev.log("you are verified");
                      displayToastMessage("you are verified", context);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/Home/MapGoogle/', (route) => false);
                    } else {
                      dev.log("you are not verified");
                    }
                  },
                  child: const Text(
                    "Reload",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void displayToastMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
  // Navigator.push(context,"somtuind");
}
