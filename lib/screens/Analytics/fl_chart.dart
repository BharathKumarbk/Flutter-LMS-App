import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/screens/Analytics/course_analytics.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class PieChartList extends StatefulWidget {
  final String courseId;
  final String userId;
  const PieChartList({
    Key key,
    this.courseId,
    this.userId,
  }) : super(key: key);
  @override
  _PieChartListState createState() => _PieChartListState();
}

class _PieChartListState extends State<PieChartList> {
  @override
  Widget build(BuildContext context) {
    var courseRepo = Provider.of<FirebaseCourseRepo>(context);
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: StreamBuilder(
          stream: courseRepo.getListofAssessmentFromPurchased(
              widget.courseId, widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PurchasedSingleQuiz> quiz = snapshot.data;
              return GridView.builder(
                  itemCount: quiz.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      child: FlatButton(
                        onPressed: quiz[index].quizFinished == "No"
                            ? () {}
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CourseAnalytics(
                                          title: quiz[index].quizTitle,
                                          quiz: quiz[index],
                                        )));
                              },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            quiz[index].quizFinished == "No"
                                ? Container(
                                    height: 120.0,
                                    color: Colors.indigo[50],
                                    child: Center(
                                      child: Text(
                                        "Exam not Attended",
                                        style: kGoogleNun,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 120.0,
                                    child: PieChart(
                                      PieChartData(
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 2.0,
                                          centerSpaceColor: kWhite,
                                          centerSpaceRadius: 20,
                                          sections: showingSections(
                                              quiz[index].quizMark,
                                              "${int.parse(quiz[index].quizTotal) - int.parse(quiz[index].quizMark)}")),
                                    ),
                                  ),
                            Text(
                              "${quiz[index].quizTitle}",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: kGoogleNun.copyWith(
                                  fontSize: 16.0, color: kBlack),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return spinLoader();
            }
          },
        ));
  }
}

List<PieChartSectionData> showingSections(String correct, String wrong) {
  return [
    PieChartSectionData(
      color: secondaryColor,
      value: double.parse(correct),
      title: (correct == "0") ? "" : correct,
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
    PieChartSectionData(
      color: Colors.red[200],
      value: double.parse(wrong),
      title: (wrong == "0") ? "" : wrong,
      radius: 35,
      titleStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
  ];
}
