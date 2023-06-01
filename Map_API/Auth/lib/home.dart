import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child:const Text(
          'Welcome to Home',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
