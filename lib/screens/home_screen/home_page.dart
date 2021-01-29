import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/horizontal_course_grid/Course_grid_module.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/components/vertical_course_grid_more/list_course_more.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/Analytics/piechart_home.dart';
import 'package:merit_coaching_app1/screens/home_screen/home_page_top.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseUserService userService = FirebaseUserService();
  AuthenticationService user = AuthenticationService();
  @override
  void initState() {
    var androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInit = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);
    super.initState();
  }

  Future showNotification(int id, String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Merit Coaching", "App to learn",
        importance: Importance.max);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  Future showWelcomeNotification(String userId) async {
    try {
      await userService.getSingleUserData(userId).then((value) async {
        if (value.firstUser == "true") {
          await showNotification(
              0,
              "Welcome to Merit Coaching ${value.userName == "no name" ? "" : value.userName}",
              "Thank you for choosing us, Enjoy learning");
          await userService.updateFirstUserData(value.userId);
        }
      });
    } catch (e) {}
  }

  @override
  void didChangeDependencies() {
    showWelcomeNotification(user.userCred.uid);
    super.didChangeDependencies();
  }

  Tween<double> tween = Tween<double>(begin: 1.0, end: 1.0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);
    final user = Provider.of<AuthenticationService>(context);
    final userService = Provider.of<FirebaseUserService>(context);
    final logic = Provider.of<FirebaseCourseLogic>(context);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: kWhite,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: TweenAnimationBuilder(
                    tween: tween,
                    duration: Duration(seconds: 1),
                    child: Container(
                      color: kWhite,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: logic.getRecentId(user.userCred.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String id = snapshot.data;
                                return Container(
                                  child: PieChartHome(
                                    courseId: id,
                                    userId: user.userCred.uid,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          StreamBuilder(
                            stream:
                                userService.getStreamUser(user.userCred.uid),
                            builder: (context, snapshot) {
                              FirebaseAppUser course = snapshot.data;

                              if (snapshot.hasData) {
                                return course.userClass == ""
                                    ? Container()
                                    : CourseGridModule(
                                        title: "Class ${course.userClass}",
                                        course: provider.getListCoursebyClass(
                                            course.userClass),
                                      );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          CourseGridModule(
                            title: "Top Free",
                            course: provider.getListofCourseBy("free"),
                          ),
                          CourseGridModule(
                            title: "Top Paid",
                            course: provider.getListofCourseBy("paid"),
                          ),
                          CourseGridModule(
                            title: "Short Courses",
                            course: provider.getListofCourseBy("short"),
                          ),
                          CourseGridModule(
                            title: "Top courses",
                            course: provider.getListofCourseBy("topEnrolled"),
                          ),
                        ],
                      ),
                    ),
                    builder: (context, tween, child) {
                      return Opacity(
                        opacity: tween,
                        child: child,
                      );
                    })),
          ),
          HomePageTop()
        ],
      ),
    );
  }
}
