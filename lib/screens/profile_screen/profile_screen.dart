import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/horizontal_course_grid/Course_grid_module.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/profile_screen/profile.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenticationService>(context);
    final courseRepo = Provider.of<FirebaseCourseRepo>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backColor,
        // backgroundColor: secondaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipOval(
              child: Container(
                height: 30.0,
                width: 30.0,
                color: kWhite,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset("assets/images/meritLogo.png"),
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              "Merit Coaching",
              style: kGoogleNun.copyWith(
                  color: kWhite, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: kWhite,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: StreamBuilder(
            stream:
                courseRepo.getListoCoursefromPurchased(provider.userCred.uid),
            builder: (context, snapshot) {
              List<SingleCourseModel> course = snapshot.data;
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Profile(
                        enrolled: course.length,
                      ),
                      CourseAnalystGrid(
                        userId: provider.userCred.uid,
                        title: "Your Performance",
                        data: course,
                      ),
                    ],
                  ),
                );
              } else {
                return progressBar();
              }
            },
          )),
    );
  }
}

showSigningOut(BuildContext context) {
// flutter defined function
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
// return object of type Dialog
      return AlertDialog(
        title: Row(
          children: [
            Center(
                child: SpinKitChasingDots(
              color: secondaryColor,
            )),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Signing out",
              style: kGoogleNun.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    },
  );
}
