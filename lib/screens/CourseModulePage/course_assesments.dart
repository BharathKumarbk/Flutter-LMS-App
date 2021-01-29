import 'package:flutter/material.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/screens/quizModulePage/quizScreen.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:provider/provider.dart';

class CourseAssesment extends StatelessWidget {
  final String courseId;
  final String userId;
  const CourseAssesment({
    Key key,
    this.courseId,
    this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FirebaseCourseRepo>(context);
    var logic = Provider.of<FirebaseCourseLogic>(context);
    var user = Provider.of<AuthenticationService>(context);
    return StreamBuilder(
      stream: provider.getListAssessmentforPurchased(courseId, userId),
      builder: (context, snapshot) {
        List<PurchasedSingleQuiz> quiz = snapshot.data;
        if (snapshot.hasData) {
          if (quiz.length == 0) {
            return emptyWidget("No Assessments posted", context);
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: quiz.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: quiz[index].quizFinished == "No"
                      ? () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FlatButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.warning,
                                          color: Colors.red[400],
                                        ),
                                        label: Text(
                                          "Warning",
                                          style: kGoogleNun.copyWith(
                                              color: Colors.red[400],
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              " - Exam can be attended only once.",
                                              style: kGoogleNun.copyWith(
                                                  color: kBlack,
                                                  fontSize: 18.0),
                                            ),
                                            Text(
                                              " - If you exit the exam inbetween your scored marks upto the point only considered.",
                                              style: kGoogleNun.copyWith(
                                                  color: kBlack,
                                                  fontSize: 18.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: kGoogleNun.copyWith(
                                                      color: secondaryColor),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TestQuestionScreen(
                                                                question:
                                                                    quiz[index],
                                                                courseId:
                                                                    courseId,
                                                                courseLogic:
                                                                    logic,
                                                                user: user,
                                                              )));
                                                },
                                                child: Text(
                                                  "Proceed",
                                                  style: kGoogleNun.copyWith(
                                                      color: secondaryColor),
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                      : () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: kWhite,
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "ok",
                                          style: kGoogleNun.copyWith(
                                              color: secondaryColor),
                                        ))
                                  ],
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.info,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "You have already finished the Exam , you cannot attend the exam twice :(",
                                            style: kGoogleNun.copyWith(
                                                color: kBlack, fontSize: 18.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                  title: Text(
                    "${quiz[index].quizTitle}",
                    style: kGoogleNun.copyWith(
                        fontSize: 18.0,
                        color: kBlack,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.question_answer,
                          color: secondaryColor,
                          size: 14.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "${quiz[index].quizData.length} Questions",
                            style: kGoogleNun.copyWith(color: kBlack),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        quiz[index].quizFinished == "No"
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.dangerous,
                                    color: Colors.red,
                                    size: 14.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      "unAttended",
                                      style: kGoogleNun.copyWith(
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: tealColor,
                                    size: 14.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      "Attended",
                                      style:
                                          kGoogleNun.copyWith(color: tealColor),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  leading: ClipOval(
                      child: Container(
                    height: 40.0,
                    width: 40.0,
                    color: secondaryColor,
                    child: Icon(
                      Icons.assessment,
                      color: kWhite,
                    ),
                  )),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kBlack,
                    size: 14.0,
                  ),
                );
              },
            );
          }
        } else {
          return spinLoader();
        }
      },
    );
  }
}
