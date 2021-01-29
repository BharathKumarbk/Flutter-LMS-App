import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:shimmer/shimmer.dart';

import 'fl_chart.dart';

class Analytics extends StatefulWidget {
  final SingleCourseModel course;
  final String userId;

  const Analytics({
    Key key,
    this.course,
    this.userId,
  }) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: NestedScrollView(
          headerSliverBuilder: (context, boolval) {
            return [
              SliverAppBar(
                backgroundColor: backColor,
                elevation: 0.0,
                expandedHeight: 180.0,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.course.courseImageUrl,
                        placeholder: (context, url) => SizedBox(
                          height: 80.0,
                          child: Shimmer.fromColors(
                            baseColor: kWhite,
                            highlightColor: Colors.white24,
                            child: Container(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/noimage.png"),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.transparent,
                            Colors.black26,
                            Colors.black45,
                            Colors.black87
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                    Column(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "${widget.course.courseName.capitalize()}",
                            style: kGoogleNun.copyWith(
                                fontSize: 24.0, color: kWhite),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
            ];
          },
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: titleText("Exam Analytics"),
                  ),
                  PieChartList(
                    userId: widget.userId,
                    courseId: widget.course.courseId,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

Widget chipText(Color color, String title) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    margin: const EdgeInsets.all(4.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10.0,
          backgroundColor: color,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "$title",
          style: kGoogleMont.copyWith(),
        ),
      ],
    ),
  );
}
