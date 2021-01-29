import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasedSingleQuiz {
  final String quizTime;
  final String quizTitle;
  final String quizId;
  final List<String> quizAnswers;
  final String quizFinished;
  final String quizMark;
  final String quizTotal;
  final List<SingleQuestion> quizData;
  PurchasedSingleQuiz({
    this.quizTime,
    this.quizTitle,
    this.quizId,
    this.quizAnswers,
    this.quizFinished,
    this.quizMark,
    this.quizTotal,
    this.quizData,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizTime': quizTime,
      'quizTitle': quizTitle,
      'quizId': quizId,
      'quizAnswers': quizAnswers,
      'quizFinished': quizFinished,
      'quizMark': quizMark,
      'quizTotal': quizTotal,
      'quizData': quizData?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory PurchasedSingleQuiz.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return PurchasedSingleQuiz(
      quizTime: map.data()['quizTime'],
      quizTitle: map.data()['quizTitle'],
      quizId: map.data()['quizId'],
      quizAnswers: List<String>.from(map.data()['quizAnswers']),
      quizFinished: map.data()['quizFinished'],
      quizMark: map.data()['quizMark'],
      quizTotal: map.data()['quizTotal'],
      quizData: List<SingleQuestion>.from(
          map.data()['quizData']?.map((x) => SingleQuestion.fromMap(x))),
    );
  }
}

class SingleQuiz {
  final String quizTime;
  final String quizTitle;
  final String quizId;
  final List<SingleQuestion> quizData;
  SingleQuiz({
    this.quizTime,
    this.quizTitle,
    this.quizId,
    this.quizData,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizTime': quizTime,
      'quizTitle': quizTitle,
      'quizId': quizId,
      'quizData': quizData.map((e) => e.toMap()).toList(),
    };
  }

  factory SingleQuiz.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleQuiz(
      quizTime: map.data()['quizTime'],
      quizTitle: map.data()['quizTitle'],
      quizId: map.data()['quizId'],
      quizData: List<SingleQuestion>.from(
          map.data()['quizData']?.map((x) => SingleQuestion.fromMap(x))),
    );
  }
}

class SingleQuestion {
  final String question;
  final List<String> options;
  final String answer;

  SingleQuestion({
    this.question,
    this.options,
    this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }

  factory SingleQuestion.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SingleQuestion(
      question: map['question'],
      options: List<String>.from(map['options']),
      answer: map['answer'],
    );
  }
}
