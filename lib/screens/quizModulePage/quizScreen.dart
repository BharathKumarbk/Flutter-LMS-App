import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/bottom_navbar/bottomNav.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/screens/Analytics/fl_chart.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';

class TestQuestionScreen extends StatefulWidget {
  final PurchasedSingleQuiz question;
  final String courseId;
  final FirebaseCourseLogic courseLogic;
  final AuthenticationService user;

  const TestQuestionScreen({
    Key key,
    this.question,
    this.courseId,
    this.courseLogic,
    this.user,
  }) : super(key: key);

  @override
  _TestQuestionScreenState createState() => _TestQuestionScreenState();
}

class _TestQuestionScreenState extends State<TestQuestionScreen> {
  final String question =
      "How do you print the first non-repeated character from a string?";
  String selected = "";
  PageController pageController = PageController();
  bool isPressed = false;
  Timer timer;
  int marks = 0;
  double percent = 0.0;
  bool result = false;
  int totalQuestion = 0;
  int questionNo = 1;
  List<String> answerList = [];

  @override
  void initState() {
    percent = percentIndicator(0, widget.question.quizData.length);
    print(widget.question.quizData.length);
    totalQuestion = widget.question.quizData.length;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    timer.cancel();
    super.dispose();
  }

  Widget optionButton(String option, String correctOption, String selected) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white54,
          width: 2.0,
        ),
        color: selected == option
            ? correctOption == option
                ? Colors.green
                : Colors.red
            : Color(0xff202848),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "$option",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              child: selected == option
                  ? correctOption == option
                      ? Icon(Icons.done, color: Colors.white)
                      : Icon(Icons.clear, color: Colors.white)
                  : Icon(Icons.clear, color: Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }

  double percentIndicator(int question, int length) {
    return (100 / length * (question + 1)) / 100;
  }

  nextQuestion(int index, int length) {
    if (index < length - 1) {
      timer = Timer(Duration(seconds: 1), () {
        setState(() {});
        pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);

        isPressed = false;
        selected = "";
        questionNo++;

        percent = percentIndicator(index + 1, length);
      });
    } else {
      timer = Timer(Duration(seconds: 1), () {
        result = true;
        isPressed = false;
        selected = "";
        setState(() {});
        percent = percentIndicator(index, length);
      });
    }
  }

  answerQuestion(String option, String correctOption, int index, int length) {
    if (option == correctOption) {
      nextQuestion(index, length);
      isPressed = true;
      selected = option;
      marks++;
    } else {
      nextQuestion(index, length);
      isPressed = true;
      selected = option;
    }
  }

  Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);

  bool isLoading = false;

  List<String> addNodata(List<String> list, int total) {
    int remain = total - list.length;
    List<String> answers = list;
    for (int i = 1; i <= remain; i++) {
      answers.add("Not Answered");
    }
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showBottomSheet(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.warning,
                    color: Colors.red[400],
                  ),
                  label: Text(
                    "Warning",
                    style: kGoogleNun.copyWith(
                        color: Colors.red[400], fontSize: 18.0),
                  ),
                ),
                content: Text(
                  "You did not finish the exam!.If you press exit you cannot able to attend the exam again!",
                  style: kGoogleNun,
                ),
                actions: [
                  FlatButton(
                      onPressed: () async {
                        await widget.courseLogic
                            .addAnswertoQuiz(
                                widget.user.userCred.uid,
                                widget.courseId,
                                widget.question.quizId,
                                addNodata(answerList, totalQuestion),
                                "$marks",
                                "${widget.question.quizData.length}")
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        "Exit",
                        style: kGoogleNun.copyWith(color: secondaryColor),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: kGoogleNun.copyWith(color: secondaryColor),
                      )),
                ],
              );
            });
      },
      child: Stack(
        children: [
          Container(color: kWhite),
          Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0.0,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.warning,
                                color: Colors.red[400],
                              ),
                              label: Text(
                                "Warning",
                                style: kGoogleNun.copyWith(
                                    color: Colors.red[400], fontSize: 18.0),
                              ),
                            ),
                            content: Text(
                              "You did not finish the exam!.If you press exit you cannot able to attend the exam again!",
                              style: kGoogleNun,
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () async {
                                    await widget.courseLogic
                                        .addAnswertoQuiz(
                                            widget.user.userCred.uid,
                                            widget.courseId,
                                            widget.question.quizId,
                                            addNodata(
                                                answerList, totalQuestion),
                                            "$marks",
                                            "${widget.question.quizData.length}")
                                        .then((value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(
                                    "Exit",
                                    style: kGoogleNun.copyWith(
                                        color: secondaryColor),
                                  )),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: kGoogleNun.copyWith(
                                        color: secondaryColor),
                                  )),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                title: Text(
                  "${widget.question.quizTitle}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: backColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 10.0,
                        width: double.infinity,
                        child: LinearPercentIndicator(
                          curve: Curves.fastOutSlowIn,
                          animation: true,
                          lineHeight: 10.0,
                          animateFromLastPercent: true,
                          animationDuration: 1000,
                          backgroundColor: Colors.transparent.withOpacity(0.4),
                          progressColor: Colors.amber,
                          percent: percent,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                        ),
                      ),
                    ),
                    Expanded(
                        child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.question.quizData.length,
                      itemBuilder: (context, pageIndex) {
                        return Container(
                          child: result
                              ? TweenAnimationBuilder(
                                  tween: tween,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Container(
                                    color: backColor,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: PieChart(
                                                  PieChartData(
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      sectionsSpace: 2.0,
                                                      centerSpaceColor: kWhite,
                                                      centerSpaceRadius: 50,
                                                      sections: showingSections(
                                                          "$marks",
                                                          "${totalQuestion - marks}")),
                                                  swapAnimationDuration:
                                                      Duration(seconds: 1),
                                                ),
                                              ),
                                              Container(
                                                height: 100.0,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: accountText(
                                                          "$marks",
                                                          "Correct",
                                                          kWhite,
                                                          secondaryColor),
                                                    ),
                                                    VerticalDivider(
                                                      color: kWhite,
                                                    ),
                                                    Expanded(
                                                      child: accountText(
                                                          "${widget.question.quizData.length - marks}",
                                                          "Wrong",
                                                          kWhite,
                                                          secondaryColor),
                                                    ),
                                                    VerticalDivider(
                                                      color: kWhite,
                                                    ),
                                                    Expanded(
                                                      child: accountText(
                                                          "$marks / ${widget.question.quizData.length}",
                                                          "Total",
                                                          kWhite,
                                                          secondaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isLoading
                                            ? spinLoader()
                                            : Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                child: RaisedButton(
                                                  color: secondaryColor,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    print(addNodata(answerList,
                                                            totalQuestion)
                                                        .toString());
                                                    await widget.courseLogic
                                                        .addAnswertoQuiz(
                                                            widget.user.userCred
                                                                .uid,
                                                            widget.courseId,
                                                            widget.question
                                                                .quizId,
                                                            addNodata(
                                                                answerList,
                                                                totalQuestion),
                                                            "$marks",
                                                            "${widget.question.quizData.length}")
                                                        .then((value) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text(
                                                    "Done",
                                                    style: kGoogleNun.copyWith(
                                                        color: kBlack),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  builder: (context, tween, child) {
                                    return Transform.scale(
                                      scale: tween,
                                      child: child,
                                    );
                                  })
                              : ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Question $questionNo",
                                          style: kGoogleNun.copyWith(
                                              color: secondaryColor,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          "Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?Which of the following is correct with respect to ${widget.question.quizData[pageIndex].question} ?",
                                          textAlign: TextAlign.center,
                                          minFontSize: 18.0,
                                          maxFontSize: 24.0,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .question
                                                .quizData[pageIndex]
                                                .options
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: new Material(
                                                    child: new InkWell(
                                                      onTap: isPressed
                                                          ? null
                                                          : () {
                                                              answerList.add(widget
                                                                  .question
                                                                  .quizData[
                                                                      pageIndex]
                                                                  .options[index]);
                                                              answerQuestion(
                                                                widget
                                                                    .question
                                                                    .quizData[
                                                                        pageIndex]
                                                                    .options[index],
                                                                pickCorrectAnswer(
                                                                    "${widget.question.quizData[pageIndex].answer}",
                                                                    widget
                                                                        .question
                                                                        .quizData[
                                                                            pageIndex]
                                                                        .options),
                                                                pageIndex,
                                                                widget
                                                                    .question
                                                                    .quizData
                                                                    .length,
                                                              );
                                                              setState(() {});
                                                            },
                                                      child: new Container(
                                                          child: optionButton(
                                                              "${widget.question.quizData[pageIndex].options[index]}",
                                                              pickCorrectAnswer(
                                                                  "${widget.question.quizData[pageIndex].answer}",
                                                                  widget
                                                                      .question
                                                                      .quizData[
                                                                          pageIndex]
                                                                      .options),
                                                              selected)),
                                                    ),
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                        );
                      },
                    ))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
