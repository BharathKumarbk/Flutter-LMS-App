import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/CourseModulePage/course.dart';
import 'package:shimmer/shimmer.dart';

class MyCourseListModule extends StatelessWidget {
  final List<SingleCourseModel> courseModel;
  const MyCourseListModule({
    Key key,
    this.courseModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: courseModel.length == 0
            ? Center(child: emptyWidget("No Course enrolled", context))
            : ListView.builder(
                itemCount: courseModel.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: RecentCourse(
                        courseModel: courseModel[index],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class RecentCourse extends StatelessWidget {
  final SingleCourseModel courseModel;

  int getPercentage(int value, int total) {
    return ((value / total) * 100).toInt();
  }

  String getTotalPercentage(int value, int total) {
    return (((value / total) * 100) / 100).toStringAsFixed(2);
  }

  const RecentCourse({
    Key key,
    this.courseModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseLogic>(context);
    final userProvider = Provider.of<AuthenticationService>(context);
    final repo = Provider.of<FirebaseCourseRepo>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: kWhite),
      child: new Material(
        child: new InkWell(
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CoursePurchasedVideo(
                      courseId: courseModel.courseId,
                      courseTitle: courseModel.courseName,
                      assess: courseModel.assessmentTime,
                      curriculum: courseModel.curriculumTime,
                      repo: repo,
                      logic: provider,
                      user: userProvider,
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
                      imageUrl: courseModel.courseImageUrl,
                      placeholder: (context, url) => SizedBox(
                        height: 60.0,
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
                )),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "${courseModel.courseName.capitalize()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: kGoogleNun.copyWith(
                                // fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: kBlack.withOpacity(0.8)),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: repo.videoSeenNum(
                            courseModel.courseId, userProvider.userCred.uid),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            int data = snapshot.data;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: LinearPercentIndicator(
                                curve: Curves.fastOutSlowIn,
                                animation: true,
                                lineHeight: 5.0,
                                animationDuration: 1000,
                                progressColor: secondaryColor,
                                percent: double.parse(
                                    "${getTotalPercentage(data ?? 0, courseModel.totalVideos)}"),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: LinearPercentIndicator(
                                curve: Curves.fastOutSlowIn,
                                animation: true,
                                lineHeight: 5.0,
                                animationDuration: 1000,
                                progressColor: secondaryColor,
                                percent: 0.0,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                              ),
                            );
                          }
                        },
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
  }
}
