import 'package:merit_coaching_app1/components/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DocList extends StatelessWidget {
  final String title;

  const DocList({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "$title",
                      overflow: TextOverflow.ellipsis,
                      style: kGoogleNun.copyWith(
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      EvaIcons.arrowForward,
                      color: secondaryColor,
                    ),
                    onPressed: () {},
                  )
                ],
              )),
          Container(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://data2.unhcr.org/images/documents/big_2c1ebb495da0d500db9a6cbb67c9fa1874d85e05.jpg")),
                      ),
                      title: Text(
                        "Questions and answer keys for social class X and XII",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: kGoogleNun.copyWith(fontSize: 14.0),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text("subtitle for Materials"),
                      ),
                      trailing: Container(
                          height: 30.0,
                          width: 50.0,
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "view",
                                  style: kGoogleNun.copyWith(color: tealColor),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Icon(
                                  EvaIcons.arrowIosForward,
                                  color: tealColor,
                                  size: 12.0,
                                ),
                              ],
                            ),
                          )));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
