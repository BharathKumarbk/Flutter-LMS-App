import 'package:cloud_firestore/cloud_firestore.dart';

class SingleFeedBack {
  final String userFeedback;
  final String userImage;
  final String userName;
  final String docId;
  final String userTime;
  final String userRating;

  SingleFeedBack({
    this.userFeedback,
    this.userImage,
    this.userName,
    this.docId,
    this.userTime,
    this.userRating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userFeedback': userFeedback,
      'userImage': userImage,
      'userName': userName,
      'docId': docId,
      'userTime': userTime,
      'userRating': userRating,
    };
  }

  factory SingleFeedBack.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleFeedBack(
      userFeedback: map.data()['userFeedback'],
      userImage: map.data()['userImage'],
      userName: map.data()['userName'],
      userTime: map.data()['userTime'],
      userRating: map.data()['userRating'],
      docId: map.data()['docId'],
    );
  }
}

class FeedBackReplies {
  final String userFeedback;
  final String userImageUrl;
  final String userName;
  final String userTime;

  FeedBackReplies(
      {this.userFeedback, this.userImageUrl, this.userName, this.userTime});

  Map<String, dynamic> toMap() {
    return {
      'userFeedback': userFeedback,
      'userImageUrl': userImageUrl,
      'userName': userName,
      'userTime': userTime,
    };
  }

  factory FeedBackReplies.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return FeedBackReplies(
      userFeedback: map.data()['userFeedback'],
      userImageUrl: map.data()['userImageUrl'],
      userName: map.data()['userName'],
      userTime: map.data()['userTime'],
    );
  }
}
