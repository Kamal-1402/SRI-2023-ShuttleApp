import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev show log;
import 'package:learn_flutter/firebase_options.dart';
// import 'package:learn_flutter/views/RegisterPage.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  late final TextEditingController email;
  late final TextEditingController password;
  bool isPasswordVisible = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Demo Home Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  ElevatedButton(
                    onPressed: () async {
                      // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      //   email: email.text,
                      //   password: password.text,
                      // );
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        dev.log('user found');
                        dev.log(userCredential.toString());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          dev.log('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          dev.log('Wrong password provided for that user.');
                        }
                      } catch (e) {
                        dev.log("user not found");
                        dev.log(e.runtimeType.toString());
                        dev.log(e.toString());
                      }

                      // Navigate to the second screen using a named route.
                    },
                    child: const Text('login'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/',
                            (route) => false);
                      },
                      child: const Text('not registered? register here'),
                  ),
                ],
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
