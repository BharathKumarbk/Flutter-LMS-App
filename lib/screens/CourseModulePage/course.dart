import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/components/videoPlayer/video_player.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

import 'Course_module.dart';

class CoursePurchasedVideo extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String assess;
  final String curriculum;
  final FirebaseCourseLogic logic;
  final FirebaseCourseRepo repo;
  final AuthenticationService user;

  const CoursePurchasedVideo({
    Key key,
    this.courseId,
    this.courseTitle,
    this.assess,
    this.curriculum,
    this.logic,
    this.repo,
    this.user,
  }) : super(key: key);

  @override
  _CoursePurchasedVideoState createState() => _CoursePurchasedVideoState();
}

class _CoursePurchasedVideoState extends State<CoursePurchasedVideo> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    updateContent(widget.logic, widget.user, widget.repo, widget.courseId,
        widget.assess, widget.curriculum);
    super.initState();
  }

  Future updateContent(
      FirebaseCourseLogic logic,
      AuthenticationService user,
      FirebaseCourseRepo repo,
      String courseId,
      String assessmentTime,
      String curriculumTime) async {
    await logic
        .setRecentCourseId(user.userCred.uid, courseId)
        .then((value) async {
      await repo.updateCoursetoUser(
          user.userCred.uid, courseId, assessmentTime, curriculumTime);
    });
  }

  String url;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: kWhite),
            backgroundColor: backColor,
            elevation: 0.0,
            title: Text(
              "${widget.courseTitle.capitalize()}",
              style: kGoogleNun,
            ),
          ),
          body: Container(
              child: CourseModule(
            courseId: widget.courseId,
            userId: widget.user.userCred.uid,
          ))),
    );
  }
}
