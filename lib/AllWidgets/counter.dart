import 'package:flutter/material.dart';

import '../configMaps.dart';

class CountWidget extends StatefulWidget {
  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  // int count = 0;

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  void decrementCount() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Column(
          children: [
            Text(
              "Passenger Count",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 50,
              icon: Icon(Icons.remove),
              color: Colors.red,
              onPressed: decrementCount,
            ),

            Text(
              count.toString(),
              style: TextStyle(fontSize: 50),
            ),
            IconButton(
              iconSize: 50,
              icon: Icon(Icons.add),
              color: Colors.green,
              onPressed: incrementCount,
            )
            // Container(
            //   height: 80,
            //   width: 80,
            //   padding: EdgeInsets.all(10),
            //   color: Colors.green,
            //   // decoration: BoxDecoration(
            //   //   borderRadius: BorderRadius.circular(1),
            //   // ),
            //   child: IconButton(
            //     icon: Icon(Icons.add),
            //     iconSize: 40,
            //     onPressed: incrementCount,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
