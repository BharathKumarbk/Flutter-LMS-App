import 'package:merit_coaching_app1/components/purchased_course/myCourse_list_module.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/components/sliverbar.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:provider/provider.dart';

class PurchasedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthenticationService>(context);
    var provider = Provider.of<FirebaseCourseRepo>(context);
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder(
        stream: provider.getListoCoursefromPurchased(user.userCred.uid),
        builder: (context, snapshot) {
          List<SingleCourseModel> listCourse = snapshot.data;
          if (snapshot.hasData) {
            return MyCourseListModule(
              courseModel: listCourse,
            );
          } else {
            return Center(child: spinLoader());
          }
        },
      ),
    );
  }
}
