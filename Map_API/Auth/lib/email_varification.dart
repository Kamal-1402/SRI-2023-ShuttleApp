import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController mobileNumber;
  bool isPasswordVisible = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    mobileNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    mobileNumber.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Aligns children to the center vertically
          children: [
            TextField(
              controller: mobileNumber,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'mobileNumber',
              ),
            ),
            
            // TextField(
            //   controller: email,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: 'Email',
            //   ),
            // ),
            // const SizedBox(height: 16), // Adds spacing between email and password fields
            // TextFormField(
            //   controller: password,
            //   obscureText: !isPasswordVisible, // Hides or shows the password
            //   decoration: InputDecoration(
            //     border: const OutlineInputBorder(),
            //     labelText: 'Password',
            //     suffixIcon: IconButton(
            //       onPressed: () {
            //         setState(() {
            //           isPasswordVisible = !isPasswordVisible; // Toggles the visibility
            //         });
            //       },
            //       icon: Icon(
            //         isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16), // Adds spacing between password field and the button
            ElevatedButton(
              onPressed: () async {
                // await Firebase.initializeApp(
                //   options: DefaultFirebaseOptions.currentPlatform,
                // );           
                // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //   email: email.text,
                //   password: password.text,
                // );
                // print(userCredential);
                // Navigate to the second screen using a named route.
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
