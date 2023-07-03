import 'package:DriverApp/Assistants/assitantMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../Models/history.dart';

class HistoryItem extends StatelessWidget {
  final History? history;
  const HistoryItem({super.key, this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "images/pickicon.png",
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          history!.pickup!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${history!.fares} ₹",
                      style: TextStyle(fontFamily: "Brand Bold"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "images/desticon.png",
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        history!.dropOff!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                AssistantMethods.formatTripDate(history!.createdAt!),
                style: TextStyle(fontFamily: "Brand Bold"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
