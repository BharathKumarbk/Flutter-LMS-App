import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SingleForum {
  final String userFeedback;

  final String docId;
  final String userId;
  final String userTime;

  SingleForum({
    this.userFeedback,
    this.docId,
    this.userId,
    this.userTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'userFeedback': userFeedback,
      'docId': docId,
      'userId': userId,
      'userTime': userTime,
    };
  }

  factory SingleForum.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleForum(
      userFeedback: map.data()['userFeedback'],
      userId: map.data()['userId'],
      userTime: map.data()['userTime'],
      docId: map.data()['docId'],
    );
  }
}

class ForumReplies {
  final String userReply;

  final String userTime;
  final String userId;

  ForumReplies({this.userReply, this.userId, this.userTime});

  Map<String, dynamic> toMap() {
    return {
      'userReply': userReply,
      'userId': userId,
      'userTime': userTime,
    };
  }

  factory ForumReplies.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return ForumReplies(
      userReply: map.data()['userReply'],
      userId: map.data()['userId'],
      userTime: map.data()['userTime'],
    );
  }
}
