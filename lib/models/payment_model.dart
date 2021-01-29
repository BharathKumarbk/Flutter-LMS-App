
import 'package:cloud_firestore/cloud_firestore.dart';

class Paymentdetails {
  final String paymentId;
  final String paymentSignature;
  final String orderId;
  final String courseId;
  final String userId;
  final String userName;
  final String userMail;
  final String courseName;
  final String coursePrice;

  Paymentdetails({
    this.paymentId,
    this.paymentSignature,
    this.orderId,
    this.courseId,
    this.userId,
    this.userName,
    this.userMail,
    this.courseName,
    this.coursePrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'paymentSignature': paymentSignature,
      'orderId': orderId,
      'courseId': courseId,
      'userId': userId,
      'userName': userName,
      'userMail': userMail,
      'courseName': courseName,
      'coursePrice': coursePrice,
    };
  }

  factory Paymentdetails.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return Paymentdetails(
      paymentId: map.data()['paymentId'],
      paymentSignature: map.data()['paymentSignature'],
      orderId: map.data()['orderId'],
      userId: map.data()['userId'],
      userName: map.data()['userName'],
      userMail: map.data()['userMail'],
      courseId: map.data()['courseId'],
      courseName: map.data()['courseName'],
      coursePrice: map.data()['coursePrice'],
    );
  }
}
