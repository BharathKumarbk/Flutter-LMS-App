

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  final String userName;
  final String userMail;
  final String userUrl;

  AppUser({
    this.userId,
    this.userMail,
    this.userName,
    this.userUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> userData) {
    return AppUser(
      userId: userData["userId"],
      userMail: userData["userMail"],
      userName: userData["userName"],
      userUrl: userData["userUrl"],
    );
  }
}

class FirebaseAppUser {
  final String userId;
  final String userName;
  final String userClass;
  final String userUrl;
  final String userMail;
  final int enrolled;
  final bool isGoogle;
  final String userVideoId;
  final String firstUser;

  FirebaseAppUser({
    this.userId,
    this.userName,
    this.userClass,
    this.userUrl,
    this.userMail,
    this.enrolled,
    this.isGoogle,
    this.userVideoId,
    this.firstUser,
  });

  factory FirebaseAppUser.fromMap(DocumentSnapshot userData) {
    return FirebaseAppUser(
      userId: userData.data()["userId"],
      userName: userData.data()["userName"],
      userMail: userData.data()["userMail"],
      userUrl: userData.data()["userUrl"],
      userClass: userData.data()["userClass"],
      userVideoId: userData.data()['userVideoId'],
      enrolled: userData.data()["enrolled"],
      isGoogle: userData.data()['isGoogle'],
      firstUser: userData.data()['firstUser'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userClass': userClass,
      'userUrl': userUrl,
      'userMail': userMail,
      'enrolled': enrolled,
      'isGoogle': isGoogle,
      'userVideoId': userVideoId,
      'firstUser': firstUser,
    };
  }
}
