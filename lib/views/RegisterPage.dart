import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:UserApp/main.dart';
import '../firebase_options.dart';
import 'dart:developer' as dev show log;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController phoneNumber;
  late final TextEditingController displayName;
  bool isPasswordVisible = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    phoneNumber = TextEditingController();
    displayName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    phoneNumber.dispose();
    displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Page'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: displayName, // Hides or shows the password
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: password,
                        obscureText:
                            !isPasswordVisible, // Hides or shows the password
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible =
                                    !isPasswordVisible; // Toggles the visibility
                              });
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneNumber, // Hides or shows the password
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mobile',
                          prefix: Text('+91 '),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          //   email: email.text,
                          //   password: password.text,
                          // );
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            dev.log(userCredential.toString());

                            usersRef.child(userCredential.user!.uid).set({
                              'displayName': displayName.text.trim(),
                              'email': email.text.trim(),
                              'phoneNumber': phoneNumber.text.trim(),
                            });
                            displayToastMessage(
                                'User created successfully', context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/Home/MapGoogle/', (route) => false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              dev.log(
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            dev.log(e.toString());
                          }

                          // Navigate to the second screen using a named route.
                        },
                        child: const Text('Register'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/', (route) => false);
                        },
                        child: const Text('already registered? login here'),
                      ),
                    ],
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
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
