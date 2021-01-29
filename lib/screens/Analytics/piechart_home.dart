import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/screens/Analytics/course_analytics.dart';
import 'package:provider/provider.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class PieChartHome extends StatefulWidget {
  final String courseId;
  final String userId;
  const PieChartHome({
    Key key,
    this.courseId,
    this.userId,
  }) : super(key: key);
  @override
  _PieChartHomeState createState() => _PieChartHomeState();
}

class _PieChartHomeState extends State<PieChartHome> {
  Tween<double> tween = Tween<double>(begin: 0.0, end: 120.0);

  @override
  Widget build(BuildContext context) {
    var courseRepo = Provider.of<FirebaseCourseRepo>(context);
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: StreamBuilder(
          stream: courseRepo.getListofAssessmentFromPurchasedByFinished(
              widget.courseId, widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PurchasedSingleQuiz> quiz = snapshot.data;
              if (quiz.length != 0) {
                return TweenAnimationBuilder(
                  tween: tween,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 1000),
                  builder: (context, tween, child) {
                    return Container(
                      height: tween,
                      child: child,
                    );
                  },
                  child: Container(
                    color: backColor,
                    height: 120.0,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: quiz.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (quiz[index].quizFinished == "No") {
                                  return Container(
                                    color: backColor,
                                  );
                                } else {
                                  return Container(
                                    color: backColor,
                                    width: 110.0,
                                    margin: const EdgeInsets.all(4.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CourseAnalytics(
                                                      title: quiz[index]
                                                          .quizTitle,
                                                      quiz: quiz[index],
                                                    )));
                                      },
                                      child: ListView(
                                        children: [
                                          Container(
                                            height: 80.0,
                                            width: 100.0,
                                            child: PieChart(
                                              PieChartData(
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 1.0,
                                                  centerSpaceColor: kWhite,
                                                  centerSpaceRadius: 10,
                                                  sections: showingsSections(
                                                      quiz[index].quizMark,
                                                      "${int.parse(quiz[index].quizTotal) - int.parse(quiz[index].quizMark)}")),
                                            ),
                                          ),
                                          AutoSizeText(
                                            "${quiz[index].quizTitle}",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: kGoogleNun.copyWith(
                                                fontSize: 16.0,
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          },
        ));
  }
}

List<PieChartSectionData> showingsSections(String correct, String wrong) {
  return [
    PieChartSectionData(
      color: secondaryColor,
      value: double.parse(correct),
      title: (correct == "0") ? "" : "$correct",
      radius: 20,
      titleStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
    PieChartSectionData(
      color: Colors.red[200],
      value: double.parse(wrong),
      title: (wrong == "0") ? "" : wrong,
      radius: 25,
      titleStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
  ];
}
