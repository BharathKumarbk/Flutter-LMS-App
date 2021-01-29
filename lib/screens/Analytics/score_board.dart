import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';

class ScoreboardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ScoreBoard",
            style: kGoogleNun,
          ),
          iconTheme: IconThemeData(color: kBlack),
          elevation: 0.0,
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return ScoreBoard();
          },
        ));
  }
}

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Half-yearly Examination ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kGoogleNun.copyWith(fontSize: 16.0),
                    ),
                  ),
                ),
                IconButton(
                    iconSize: 16.0,
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {})
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  accountText(
                    "25",
                    "Correct",
                    secondaryColor,
                    Colors.grey,
                  ),
                  Container(
                    color: tealColor,
                    width: 2.0,
                    height: 20.0,
                  ),
                  accountText(
                    "5",
                    "Wrong",
                    secondaryColor,
                    Colors.grey,
                  ),
                  Container(
                    color: tealColor,
                    width: 2.0,
                    height: 20.0,
                  ),
                  accountText(
                    "30",
                    "Total",
                    secondaryColor,
                    Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
