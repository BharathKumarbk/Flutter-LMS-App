import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/models/payment_model.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class OverView extends StatefulWidget {
  final SingleCourseModel course;
  final bool isPurchased;
  final FirebaseCourseRepo firebaseCourseRepo;
  final AuthenticationService authenticationService;
  final AppUser appUser;

  const OverView({
    Key key,
    this.course,
    this.isPurchased,
    this.firebaseCourseRepo,
    this.authenticationService,
    this.appUser,
  }) : super(key: key);
  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  TextEditingController descriptionControler = TextEditingController();
  Razorpay _razorpay;

  @override
  void initState() {
    var androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInit = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    descriptionControler.dispose();
  }

  void openCheckout() async {
    var options = {
      "key": "rzp_test_ZFpwCIDjJATAQV",
      "amount": num.parse(widget.course.coursePrice) * 100,
      "name": widget.appUser.userName,
      "description": descriptionControler.text,
      "prefill": {"contact": "", "email": widget.appUser.userMail},
      'timeout': 120, // in seconds
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  String payment = "";
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment Success");
    await widget.firebaseCourseRepo
        .getUser(widget.appUser.userId)
        .then((value) async {
      showNotification(
          1, "Thank you for Purchasing the Course", widget.course.courseName);
      await widget.firebaseCourseRepo.addPaymentDatatoUser(
          widget.appUser.userId,
          Paymentdetails(
            userId: value.userId,
            userMail: value.userMail,
            userName: value.userName,
            paymentId: response.paymentId,
            paymentSignature: response.signature,
            orderId: response.orderId,
            courseId: widget.course.courseId,
            courseName: widget.course.courseName,
            coursePrice: widget.course.coursePrice,
          ));
      await widget.firebaseCourseRepo.addCoursetoUser(
          widget.authenticationService.userCred.uid, widget.course.courseId);
      await widget.firebaseCourseRepo.updateEnrolled(widget.course.courseId);
    });

    // if (response.orderId != null && response.paymentId != null) {
    //   Fluttertoast.showToast(msg: "Course Added Successfully");

    //   await widget.firebaseCourseRepo
    //       .addPaymentDatatoUser(
    //           widget.appUser.userId,
    //           Paymentdetails(
    //             paymentId: response.paymentId,
    //             paymentSignature: response.signature,
    //             orderId: response.orderId,
    //             courseId: widget.course.courseId,
    //             courseName: widget.course.courseName,
    //             coursePrice: widget.course.coursePrice,
    //           ))
    //       .then((value) async => await widget.firebaseCourseRepo
    //           .addCoursetoUser(widget.authenticationService.userCred.uid,
    //               widget.course.courseId));
    // }
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Payment External");
  }

  @override
  Widget build(BuildContext context) {
  
  

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isPurchased
              ? Container(
                  height: 1.0,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: FlatButton(
                              minWidth: double.infinity,
                              color: secondaryColor,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          height: 400.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 100.0,
                                                color: kWhite,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 80.0,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: Image(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  widget.course
                                                                      .courseImageUrl)),
                                                        ),
                                                      ),
                                                    )),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "${widget.course.courseName.capitalize()}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                          style: kGoogleNun
                                                              .copyWith(
                                                            color: kBlack,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    priceText(widget.course
                                                                .coursePrice) ==
                                                            "free"
                                                        ? "free"
                                                        : "${priceText(widget.course.coursePrice)}/-",
                                                    style: kGoogleNun.copyWith(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  maxLines: null,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return "Field should not be empty";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      descriptionControler,
                                                  decoration: InputDecoration(
                                                      hintText: "Description",
                                                      hintStyle:
                                                          kGoogleMont.copyWith(
                                                              color: Colors
                                                                  .black26),
                                                      fillColor: kWhite,
                                                      filled: true,
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                child: FlatButton(
                                                  color: secondaryColor,
                                                  onPressed: () async {
                                                    if (widget.course
                                                            .coursePrice ==
                                                        "free") {
                                                      Navigator.pop(context);

                                                      await widget
                                                          .firebaseCourseRepo
                                                          .getUser(widget
                                                              .appUser.userId)
                                                          .then((value) async {
                                                        showNotification(
                                                            1,
                                                            "Thank you for Purchasing the Course",
                                                            widget.course
                                                                .courseName);
                                                        await widget
                                                            .firebaseCourseRepo
                                                            .addPaymentDatatoUser(
                                                                widget.appUser
                                                                    .userId,
                                                                Paymentdetails(
                                                                  userId: value
                                                                      .userId,
                                                                  userMail: value
                                                                      .userMail,
                                                                  userName: value
                                                                      .userName,
                                                                  paymentId:
                                                                      "free course",
                                                                  paymentSignature:
                                                                      "free course",
                                                                  orderId:
                                                                      "free course",
                                                                  courseId: widget
                                                                      .course
                                                                      .courseId,
                                                                  courseName: widget
                                                                      .course
                                                                      .courseName,
                                                                  coursePrice: widget
                                                                      .course
                                                                      .coursePrice,
                                                                ));
                                                        await widget.firebaseCourseRepo
                                                            .addCoursetoUser(
                                                                widget
                                                                    .authenticationService
                                                                    .userCred
                                                                    .uid,
                                                                widget.course
                                                                    .courseId);
                                                        await widget
                                                            .firebaseCourseRepo
                                                            .updateEnrolled(
                                                                widget.course
                                                                    .courseId);
                                                      });
                                                    } else {
                                                      openCheckout();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(
                                                    "Check out",
                                                    style: kGoogleNun.copyWith(
                                                        color: kWhite),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                "Buy Now",
                                style: kGoogleNun.copyWith(color: kWhite),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.course.courseName.capitalize(),
                style: kGoogleNun.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: backColor)),
          ),
          SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Description",
                style: kGoogleNun.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: kBlack)),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.course.courseDescription,
                style: kGoogleNun.copyWith(fontSize: 14.0, color: kBlack)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              chipText(Icons.class_, "Class ${widget.course.courseClass}"),
              Divider(),
              chipText(Icons.supervisor_account,
                  "${widget.course.enrolled ?? "0"}  Enrolled"),
              Divider(),
              chipText(Icons.language, "${widget.course.language}"),
              Divider(),
              chipText(Icons.video_call,
                  "${widget.course.totalVideos}   On-Demand videos"),
              Divider(),
              chipText(Icons.assessment,
                  "${widget.course.totalExams}   Exam modules to evaluate yourself"),
              Divider(),
              chipText(Icons.attachment,
                  "${widget.course.totalDocuments}   Attachments to improve your skills"),
            ],
          ),
        ],
      ),
    );
  }
}

Widget chipText(IconData icon, String title) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    margin: const EdgeInsets.all(4.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: backColor,
            child: Icon(
              icon,
              color: kWhite,
              size: 18.0,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "$title",
          style: kGoogleMont.copyWith(color: kBlack),
        ),
      ],
    ),
  );
}
