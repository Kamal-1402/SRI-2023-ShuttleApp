import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../AllWidgets/HistoryItem.dart';
import 'dart:developer' as dev show log;
import '../Assistants/assitantMethods.dart';
import '../DataHandler/appData.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // AssistantMethods.retrieveHistoryInfo(context);
    AssistantMethods.obtainTripRequestHistoryData(context);
    // dev.log("getCurrentDriverInfo did not work");
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Trip History"),
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
          ),
          body: Container(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                return HistoryItem(
                  history:
                      Provider.of<AppData>(context).tripHistoryDataList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  color: Colors.black,
                  thickness: 1,
                );
              },
              itemCount: Provider.of<AppData>(context).tripHistoryDataList.length,
              // itemCount: 2,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          )

          // Container(
          //   child: ListView.separated(
          //     padding: const EdgeInsets.all(0),
          //     itemBuilder: (BuildContext context, int index) {
          //       return HistoryItem(
          //         history: Provider.of<AppData>(context, listen: false)
          //             .tripHistoryDataList[index],
          //       );
          //     },
          //     separatorBuilder: (BuildContext context, int index) {
          //       return const Divider(
          //         height: 1,
          //         color: Colors.black,
          //         thickness: 1,
          //       );
          //     },
          //     itemCount: Provider.of<AppData>(context, listen: false)
          //         .tripHistoryDataList
          //         .length,
          //     physics: const ClampingScrollPhysics(),
          //     shrinkWrap: true,
          //   ),
          // ),
          ),
    );
  }
}
