import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child:Padding(
          padding:const EdgeInsets.all(15),
          child: Row(
            children: [
               const SizedBox(
                width: 6,
              ),
              const CircularProgressIndicator(),
               const SizedBox(
                width: 26,
              ),
              Text(
                message,
                style:const  TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
