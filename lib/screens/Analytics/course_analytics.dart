import 'package:flutter/material.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';

class CourseAnalytics extends StatefulWidget {
  final String title;
  final PurchasedSingleQuiz quiz;
  const CourseAnalytics({
    Key key,
    this.title,
    this.quiz,
  }) : super(key: key);
  @override
  _CourseAnalyticsState createState() => _CourseAnalyticsState();
}

class _CourseAnalyticsState extends State<CourseAnalytics> {
  List<String> answers = [];

  @override
  void initState() {
    answers = getAnswers(widget.quiz.quizAnswers, widget.quiz.quizData.length);
    super.initState();
  }

  List<String> addNodata(List<String> list, int total) {
    int remain = total - list.length;
    List<String> answers = list;
    for (int i = 0; i < remain; i++) {
      answers.add("Not Answered");
    }
    return answers;
  }

  List<String> getAnswers(List<String> answers, int total) {
    if (!(answers.length == total)) {
      return addNodata(answers, total);
    }
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    List<String> answers = widget.quiz.quizAnswers;
    return Scaffold(
backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backColor,
        title: Text("${widget.title}"),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        physics: BouncingScrollPhysics(),
        itemCount: widget.quiz.quizData.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Question ${index + 1}",
                  style: kGoogleNun.copyWith(
                      fontSize: 16.0,
                      color: backColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.quiz.quizData[index].question}",
                    style: kGoogleNun.copyWith(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.quiz.quizData[index].options.length,
                itemBuilder: (context, optionIndex) {
                  return ListTile(
                    leading: ClipOval(
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        color: secondaryColor,
                        child: Center(
                            child: Text(
                          "${optionIndex + 1}",
                          style: kGoogleNun.copyWith(color: kWhite),
                        )),
                      ),
                    ),
                    title: Text(
                      widget.quiz.quizData[index].options[optionIndex],
                      style: kGoogleNun.copyWith(color: kBlack),
                    ),
                  );
                },
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: titleText("Correct Answer :    "),
                          ),
                          Expanded(
                            child: Text(
                              pickCorrectAnswer(
                                  widget.quiz.quizData[index].answer,
                                  widget.quiz.quizData[index].options),
                              style: kGoogleNun.copyWith(
                                fontWeight: FontWeight.w500,
                                color: kBlack,
                                fontSize: 18.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: titleText("Your Answer :    "),
                          ),
                          Expanded(
                            child: Text(
                              "${answers[index]}",
                              style: kGoogleNun.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: (pickCorrectAnswer(
                                              widget
                                                  .quiz.quizData[index].answer,
                                              widget.quiz.quizData[index]
                                                  .options) ==
                                          answers[index])
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget answertile(String title, String answer, [String checkAnswer]) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: titleText("$title : "),
        ),
        Expanded(
          child: Text(
            "$answer",
            style: kGoogleNun.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
        )
      ],
    ),
  );
}
