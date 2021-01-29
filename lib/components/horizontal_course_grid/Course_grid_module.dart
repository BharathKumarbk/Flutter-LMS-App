import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/horizontal_course_grid/Course_grid_horizontal_list.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/components/vertical_course_grid_more/list_course_more.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/Analytics/analytics.dart';
import 'package:shimmer/shimmer.dart';


class CourseGridModule extends StatelessWidget {
  final String title;
  final Stream course;

  const CourseGridModule({
    Key key,
    this.title,
    this.course,
  }) : super(key: key);

  String formatNum(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: course,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SingleCourseModel> data = snapshot.data;
          if (data.length != 0) {
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
                            child: titleText(title),
                          ),
                          IconButton(
                            icon: Icon(
                              EvaIcons.arrowForward,
                              color: secondaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ListCourseMore(
                                  title: title,
                                  courseStream: data ?? SingleCourseModel(),
                                );
                              }));
                            },
                          )
                        ],
                      )),
                  CourseGridHorizontalList(course: data),
                  Divider(
                    color: kBlack.withOpacity(0.1),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CourseAnalystGrid extends StatelessWidget {
  final String title;
  final List<SingleCourseModel> data;
  final String userId;

  const CourseAnalystGrid({
    Key key,
    this.title,
    this.data,
    this.userId,
  }) : super(key: key);

  String formatNum(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 150.0),
        child: Container(
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
                        child: titleText(title),
                      ),
                      IconButton(
                        icon: Icon(
                          EvaIcons.arrowForward,
                          color: secondaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PerformnceList(
                              title: title,
                              courseModel: data,
                              userId: userId,
                            );
                          }));
                        },
                      )
                    ],
                  )),
              data.length == 0
                  ? Center(child: emptyWidget("No course enroled", context))
                  : CoursePerformanceGrid(
                      course: data,
                      userId: userId,
                    )
            ],
          ),
        ));
  }
}

class PerformnceList extends StatelessWidget {
  final String title;
  final String userId;
  final List<SingleCourseModel> courseModel;

  const PerformnceList({
    Key key,
    this.title,
    this.courseModel,
    this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text(
            "$title",
            style: kGoogleNun.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor: backColor,
        ),
        body: courseModel.isEmpty
            ? Center(child: emptyWidget("$title is Empty", context))
            : ListView.builder(
                itemCount: courseModel.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: kWhite),
                    child: new Material(
                      child: new InkWell(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Analytics(
                                    course: courseModel[index],
                                    userId: userId,
                                  )));
                        },
                        child: Container(
                          height: 65.0,
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 65.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: courseModel[index].courseImageUrl,
                                    placeholder: (context, url) => SizedBox(
                                      height: 60.0,
                                      child: Shimmer.fromColors(
                                        baseColor: kWhite,
                                        highlightColor: Colors.white24,
                                        child: Container(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/noimage.png"),
                                  ),
                                ),
                              )),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${courseModel[index].courseName.capitalize()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: kGoogleNun.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: kBlack.withOpacity(0.8)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  );
                },
              ));
  }
}

class CoursePerformanceGrid extends StatefulWidget {
  final List<SingleCourseModel> course;
  final String userId;
  const CoursePerformanceGrid({
    Key key,
    this.course,
    this.userId,
  }) : super(key: key);
  @override
  _CoursePerformanceGridState createState() => _CoursePerformanceGridState();
}

class _CoursePerformanceGridState extends State<CoursePerformanceGrid> {
  List<SingleCourseModel> courseModel = [];
  @override
  void initState() {
    courseModel = getListofCourse(widget.course);
    super.initState();
  }

  List<SingleCourseModel> getListofCourse(List<SingleCourseModel> course) {
    if (course.length < 10) {
      return course.sublist(0, course.length);
    } else {
      return course.sublist(0, 11);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView.builder(
        itemCount: courseModel.length,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
              width: 180.0,
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80.0,
                            width: 180.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: courseModel[index].courseImageUrl,
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
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: AutoSizeText(
                                "${courseModel[index].courseName}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: kGoogleNun.copyWith(
                                  color: kBlack,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: 180.0,
                    height: 150.0,
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(10.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Analytics(
                                    course: courseModel[index],
                                    userId: widget.userId,
                                  )));
                        },
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
