import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/purchased_course/myCourse_list_module.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:provider/provider.dart';

class HomePageTop extends StatefulWidget {
  @override
  _HomePageTopState createState() => _HomePageTopState();
}

class _HomePageTopState extends State<HomePageTop> {
  Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<FirebaseCourseRepo>(context);
    final user = Provider.of<AuthenticationService>(context);

    final logic = Provider.of<FirebaseCourseLogic>(context);
    return FutureBuilder(
      future: logic.getRecentId(user.userCred.uid),
      builder: (context, snapshot) {
        String courseId = snapshot.data;
        if (courseId != "") {
          return StreamBuilder(
            stream:
                repo.getSingleCoursefromPurchased(user.userCred.uid, courseId),
            builder: (context, snapshot) {
              SingleCourseModel data = snapshot.data;
              if (snapshot.hasData) {
                return TweenAnimationBuilder(
                  tween: tween,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 200),
                  builder: (context, tween, child) {
                    return Transform.scale(
                      // origin: Offset(50.0, 50.0),

                      scale: tween,
                      child: child,
                    );
                  },
                  child: Container(
                    color: backColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RecentCourse(
                            courseModel: data,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
