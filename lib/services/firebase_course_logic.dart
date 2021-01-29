import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/models/forum_model.dart';
import 'package:merit_coaching_app1/models/payment_model.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:uuid/uuid.dart';

class FirebaseCourseLogic extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future saveToFavourites(String userId, String courseId) async {
    DocumentReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId);
    DocumentSnapshot documentSnapshot = await reference.get();
    List favourites = documentSnapshot.data()["favouriteUsers"];
    if (favourites.contains(userId) == true) {
      reference.update({
        'favouriteUsers': FieldValue.arrayRemove([userId])
      });
    } else {
      reference.update({
        'favouriteUsers': FieldValue.arrayUnion([userId])
      });
    }
  }

  Future updateUser(bool isGoogle, String userID,
      {File image, String url, String userName, String userClass}) async {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    StorageRepo repo = StorageRepo();
    try {
      if (isGoogle) {
        await userReference.doc(userID).update({
          "userClass": userClass,
        });
      } else {
        if (url == "") {
          await repo.uploadFile(image).then((value) async {
            await userReference.doc(userID).update({
              "userClass": userClass,
              "userUrl": value,
              "userName": userName,
            });
          });
        } else if (url != "" && image == null) {
          await userReference.doc(userID).update({
            "userClass": userClass,
            "userUrl": url,
            "userName": userName,
          });
        } else {
          await repo.deleteImage(url).then((value) async {
            await repo.uploadFile(image).then((value) async {
              await userReference.doc(userID).update({
                "userClass": userClass,
                "userUrl": value,
                "userName": userName,
              });
            });
          });
        }
      }
    } catch (e) {}
  }

  Future<String> getListofId(userId) async {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    try {
      return await userReference
          .where("userId", isEqualTo: userId)
          .get()
          .then((value) {
        if (value.size == 0) {
          return "true";
        } else {
          return "false";
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future setRecentCourseId(String userId, String courseId) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId);

    try {
      await userReference.update({
        "courseId": courseId,
      });
    } catch (e) {}
  }

  Future<String> getRecentId(String userId) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId);

    try {
      return await userReference
          .get()
          .then((value) => value.data()["courseId"]);
    } catch (e) {
      return null;
    }
  }

  Future<String> getRecentVideoId(String userId) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId);

    try {
      return await userReference
          .get()
          .then((value) => value.data()["userVideoId"]);
    } catch (e) {
      return null;
    }
  }

  Future setRecentVideoId(
      String userId, String courseId, String videoId) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId);

    try {
      await userReference.update({
        "userVideoId": videoId,
      });
    } catch (e) {}
  }

  Stream<SingleCurriculumVideo> getRecentVideo(
      String userId, String courseId, String videoId) {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId);

    try {
      if (videoId == "") {
        return userReference
            .collection("curriculum")
            .orderBy("videoTime")
            .snapshots()
            .map((event) => SingleCurriculumVideo.fromMap(event.docs.first));
      } else {
        return userReference
            .collection("curriculum")
            .doc(videoId)
            .snapshots()
            .map((event) => SingleCurriculumVideo.fromMap(event));
      }
    } catch (e) {
      return null;
    }
  }

  Future<SingleVideo> getSingeVideo(
      String userId, String courseId, String videoId) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculum")
        .doc(videoId);
    try {
      return userReference.get().then((value) => SingleVideo.fromMap(value));
    } catch (e) {
      return null;
    }
  }

  Future addAnswertoQuiz(String userId, String courseId, String docId,
      List<String> data, String marks, String total) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("Assessment")
        .doc(docId);

    try {
      await userReference.update({
        "quizAnswers": data,
        "quizFinished": "Yes",
        "quizMark": marks,
        "quizTotal": total,
      });
    } catch (e) {}
  }

  Future<List<SingleFeedBack>> getOverAllRatings(String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("feedback");
    try {
      return await reference.get().then(
          (value) => value.docs.map((e) => SingleFeedBack.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  String calculateRatings(List<String> ratings) {
    double sumRatings = 0.0;
    double sumTotal;

    ratings.forEach((r) => sumRatings += double.parse(r));
    sumTotal = ratings.length * 5.0;
    return (sumRatings / sumTotal * 5.0).toStringAsFixed(1);
  }

  Future updateRatings(String courseId) async {
    DocumentReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId);

    List<String> ratingsList = [];
    try {
      await getOverAllRatings(courseId).then((value) {
        value.forEach((e) => ratingsList.add(e.userRating));
      });

      // debugPrint(ratingsList.toString());

      String rating = calculateRatings(ratingsList);
      await reference.update({
        "courseRating": rating,
      });
    } catch (e) {
      return null;
    }
  }

  Future addFeedback(
    String courseId,
    String name,
    String feedback,
    String rating,
    String imageUrl,
  ) async {
    DocumentReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId);

    final uid = Uuid().v4();
    await reference.collection("feedback").doc(uid).set(SingleFeedBack(
          userName: name,
          userFeedback: feedback,
          docId: uid,
          userImage: imageUrl,
          userRating: rating,
          userTime: DateTime.now().toString(),
        ).toMap());
  }

  Future addForum(
    String courseId,
    String name,
    String feedback,
  ) async {
    DocumentReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId);

    final uid = Uuid().v4();
    await reference.collection("forum").doc(uid).set(SingleForum(
          userId: name,
          userFeedback: feedback,
          docId: uid,
          userTime: DateTime.now().toString(),
        ).toMap());
  }

  Future addFeedbackReply(String courseId, String name, String feedback,
      String imageUrl, String docId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("feedback");
    await reference.doc(docId).collection("replies").add(FeedBackReplies(
          userName: name,
          userFeedback: feedback,
          userImageUrl: imageUrl,
          userTime: DateTime.now().toString(),
        ).toMap());
  }

  Future addForumReply(
      String courseId, String name, String reply, String docId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("forum");
    await reference.doc(docId).collection("replies").add(ForumReplies(
          userId: name,
          userReply: reply,
          userTime: DateTime.now().toString(),
        ).toMap());
  }


  

}

String calculateRating(List<String> ratings) {
  double sumRatings = 0.0;
  double sumTotal;

  ratings.forEach((r) => sumRatings += double.parse(r));
  sumTotal = ratings.length * 5.0;
  return (sumRatings / sumTotal * 5.0).toStringAsFixed(1);
}
