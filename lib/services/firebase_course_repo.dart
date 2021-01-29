import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/attach_doc_model.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/models/forum_model.dart';
import 'package:merit_coaching_app1/models/payment_model.dart';
import 'package:merit_coaching_app1/models/quiz_model.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/screens/detailScreen/curriculam.dart';

class FirebaseCourseRepo extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<SingleCourseModel>> getListofCourseByFavourites(String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");

    try {
      return reference
          .where("favouriteUsers", arrayContains: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((document) {
          return SingleCourseModel.fromMap(document);
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Stream<IntroVideo> getIntroVideo(String courseId) {
    DocumentReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("introVideo")
        .doc("intro");

    try {
      return reference.snapshots().map((event) => IntroVideo.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleVideo>> getFirstVideo(String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculum");

    try {
      return reference.orderBy("videoTime").snapshots().map(
          (event) => event.docs.map((e) => SingleVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

/////////////////////////////////////////////////////////////////////////////
//add course to user purchased

  Future updateEnrolled(String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      await reference.doc(courseId).update({
        "enrolledUsers": FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateVideoSeen(String courseId, String userId, String videoId) async {
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
      await userReference.update({
        "videoSeen": "true",
      });
    } catch (e) {}
  }

  Future updateVideoNum(
    String courseId,
    String userId,
  ) async {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId);

    try {
      await userReference.update({
        "videosWatched": FieldValue.increment(1),
      });
    } catch (e) {
      return null;
    }
  }

  Stream<int> videoSeenNum(String courseId, String userId) {
    DocumentReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId);

    try {
      return userReference
          .collection("curriculum")
          .where("videoSeen", isEqualTo: "true")
          .snapshots()
          .map((event) => event.docs.length);
    } catch (e) {
      return null;
    }
  }

  Future addPaymentDatatoUser(
      String userId, Paymentdetails paymentdetails) async {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Paymentdata");

    try {
      await userReference.add(paymentdetails.toMap());
    } catch (e) {}
  }

  Future addCoursetoUser(String userId, String courseId) async {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased");

    await getSingleCoursebyIdforPurchased(
      courseId,
    )
        .then((value) => userReference.doc(courseId).set(value.toMap()))
        .then((value) async {
      await getSingleCurriculumforPurchased(courseId).then((value) {
        value.forEach((e) {
          userReference
              .doc(courseId)
              .collection("curriculum")
              .doc(e.videoId)
              .set(e.toMap());
        });
      });
      await getSingleAttachmentsforPurchased(courseId)
          .then((value) => value.forEach((element) {
                userReference
                    .doc(courseId)
                    .collection("attachments")
                    .doc(element.docId)
                    .set(element.toMap());
              }));
      await getSingleChapterListforPurchased(courseId).then((value) {
        userReference
            .doc(courseId)
            .collection("curriculumchapter")
            .doc("chapters")
            .set(value.toMap());
      });
      await getSingleAssessmentforPurchased(courseId)
          .then((value) => value.forEach((element) {
                userReference
                    .doc(courseId)
                    .collection("Assessment")
                    .doc(element.quizId)
                    .set(element.toMap());
              }));
      await userReference
          .doc(courseId)
          .collection("videoWatched")
          .doc("videoseen")
          .set({
        "progress": 0,
      });
      await getSingleAssessmentforPurchased(courseId)
          .then((value) => value.forEach((element) {
                userReference
                    .doc(courseId)
                    .collection("Assessment")
                    .doc(element.quizId)
                    .update({
                  "quizAnswers": FieldValue.arrayUnion([]),
                  "quizFinished": "No",
                  "quizMark": "",
                  "quizTotal": "",
                });
              }));
    });
  }

  Future<bool> updateCoursetoUser(String userId, String courseId,
      String assessTime, String videoTime) async {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased");

    try {
      return await getSingleCoursebyIdforPurchased(
        courseId,
      ).then((value) async {
        await getSingleAttachmentsforPurchased(value.courseId)
            .then((value) => value.forEach((element) {
                  userReference
                      .doc(courseId)
                      .collection("attachments")
                      .doc(element.docId)
                      .set(element.toMap());
                }));
        await getSingleCurriculumforPurchasedFilter(courseId, videoTime)
            .then((value) {
          value.forEach((e) {
            userReference
                .doc(courseId)
                .collection("curriculum")
                .doc(e.videoId)
                .set(e.toMap());
          });
        });
        await getSingleChapterListforPurchased(courseId).then((value) {
          userReference
              .doc(courseId)
              .collection("curriculumchapter")
              .doc("chapters")
              .set(value.toMap());
        });

        await getSingleAssessmentforPurchasedFilter(courseId, assessTime)
            .then((value) => value.forEach((element) {
                  userReference
                      .doc(courseId)
                      .collection("Assessment")
                      .doc(element.quizId)
                      .set(element.toMap());
                }));

        await getSingleAssessmentforPurchasedFilter(courseId, assessTime)
            .then((value) => value.forEach((element) {
                  userReference
                      .doc(courseId)
                      .collection("Assessment")
                      .doc(element.quizId)
                      .update({
                    "quizAnswers": FieldValue.arrayUnion([]),
                    "quizFinished": "No",
                    "quizMark": "",
                    "quizTotal": "",
                  });
                }));
        userReference.doc(courseId).update({
          "courseId": value.courseId,
          "assessmentTime": value.assessmentTime,
          "courseName": value.courseName,
          "curriculumTime": value.curriculumTime,
          "totalDocuments": value.totalDocuments,
          "totalExams": value.totalExams,
          "totalVideos": value.totalVideos,
        });
      }).whenComplete(() => true);
    } catch (e) {
      return false;
    }
  }

  Future<FirebaseAppUser> getUser(String id) async {
    try {
      return firebaseFirestore
          .collection("School")
          .doc("User Id")
          .collection("Users")
          .doc(id)
          .get()
          .then((value) => FirebaseAppUser.fromMap(value));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<SingleCurriculumVideo>> getSingleCurriculumforPurchased(
      String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return await reference.doc(courseId).collection("curriculum").get().then(
          (value) =>
              value.docs.map((e) => SingleCurriculumVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Future<ListChapter> getSingleChapterListforPurchased(String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return await reference
          .doc(courseId)
          .collection("curriculumchapter")
          .doc("chapters")
          .get()
          .then((value) => ListChapter.fromMap(value));
    } catch (e) {
      return null;
    }
  }

  Future<ListChapter> getSingleChapterListfromPurchased(
      String courseId, String userId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculumchapter");
    try {
      return await reference
          .doc("chapters")
          .get()
          .then((value) => ListChapter.fromMap(value));
    } catch (e) {
      return null;
    }
  }

  Future<List<SingleCurriculumVideo>> getListofVideosFromFutureUsers(
      String courseId, String chapterName, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculum");

    try {
      return reference
          .where("videoChapter", isEqualTo: chapterName)
          .orderBy("videoTime")
          .get()
          .then((value) =>
              value.docs.map((e) => SingleCurriculumVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  // Future<String> logicofNextChapter(
  //     String courseId, String userId, String chapter) async {
  //   String isSeen = "false";
  //   List<String> subList = [];
  //   try {
  //     await getSingleChapterListfromPurchased(courseId, userId).then((value) {
  //       subList =
  //           value.chapterList.sublist(0, value.chapterList.indexOf(chapter));

  //       if (subList.isNotEmpty) {
  //         subList.map((element) async {
  //           await getListofVideosFromFutureUsers(courseId, element, userId)
  //               .then((value) {
  //             value.map((element) {
  //               if (element.videoSeen == "true") {
  //                 isSeen = "true";
  //               }
  //             });
  //           });
  //         });
  //       } else {
  //         isSeen = "true";
  //       }
  //     });

  //     return isSeen;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<List<AttachDoc>> getSingleAttachmentsforPurchased(
      String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return await reference.doc(courseId).collection("attachments").get().then(
          (value) => value.docs.map((e) => AttachDoc.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

//filter get list

  Future<List<SingleQuiz>> getSingleAssessmentforPurchased(
      String courseId) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("Assessment");
    try {
      return await reference.get().then(
          (value) => value.docs.map((e) => SingleQuiz.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Future<List<SingleQuiz>> getSingleAssessmentforPurchasedFilter(
      String courseId, String time) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return await reference
          .doc(courseId)
          .collection("Assessment")
          .where("quizTime", isGreaterThan: time)
          .get()
          .then(
              (value) => value.docs.map((e) => SingleQuiz.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Future<List<SingleCurriculumVideo>> getSingleCurriculumforPurchasedFilter(
      String courseId, String time) async {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return await reference
          .doc(courseId)
          .collection("curriculum")
          .where("videoTime", isGreaterThan: time)
          .get()
          .then((value) =>
              value.docs.map((e) => SingleCurriculumVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Future<SingleCourseModel> getSingleCoursebyIdforPurchased(
    String courseId,
  ) async {
    DocumentReference courseReference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId);

    return await courseReference
        .get()
        .then((value) => SingleCourseModel.fromMap(value));
  }

///////////////////////////////////////////////////////////////////////////////
//get list of courses

  Stream<List<SingleCurriculumVideo>> getListofVideosFromCourses(
      String courseId, String chapterName) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("curriculum");

    try {
      return reference
          .where("videoChapter", isEqualTo: chapterName)
          .orderBy("videoTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => SingleCurriculumVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleCurriculumVideo>> getListofVideosFromUsers(
      String courseId, String chapterName, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculum");

    try {
      return reference
          .where("videoChapter", isEqualTo: chapterName)
          .orderBy("videoTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => SingleCurriculumVideo.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<ListChapter> getListofChaptersFromCourses(String courseId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .doc(courseId)
        .collection("curriculumchapter");

    try {
      return reference
          .doc("chapters")
          .snapshots()
          .map((event) => ListChapter.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<ListChapter> getListofChaptersFromUsers(
      String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased")
        .doc(courseId)
        .collection("curriculumchapter");

    try {
      return reference
          .doc("chapters")
          .snapshots()
          .map((event) => ListChapter.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<List<PurchasedSingleQuiz>> getListofAssessmentFromPurchased(
      String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    try {
      return reference
          .doc(userId)
          .collection("purchased")
          .doc(courseId)
          .collection("Assessment")
          .orderBy("quizTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PurchasedSingleQuiz.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<PurchasedSingleQuiz>> getListofAssessmentFromPurchasedByFinished(
      String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    try {
      return reference
          .doc(userId)
          .collection("purchased")
          .doc(courseId)
          .collection("Assessment")
          .where("quizFinished", isEqualTo: "Yes")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PurchasedSingleQuiz.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<PurchasedSingleQuiz>> getListAssessmentforPurchased(
      String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    try {
      return reference
          .doc(userId)
          .collection("purchased")
          .doc(courseId)
          .collection("Assessment")
          .orderBy("quizTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PurchasedSingleQuiz.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<AttachDoc>> getListAttachmentsforPurchased(
      String courseId, String userId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users");
    try {
      return reference
          .doc(userId)
          .collection("purchased")
          .doc(courseId)
          .collection("attachments")
          .snapshots()
          .map((event) => event.docs.map((e) => AttachDoc.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleFeedBack>> getListofFeedback(String courseId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .doc(courseId)
          .collection("feedback")
          .orderBy("userTime", descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => SingleFeedBack.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleForum>> getListofForum(String courseId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .doc(courseId)
          .collection("forum")
          .orderBy("userTime", descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => SingleForum.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<FeedBackReplies>> getListofFeedbackRelpies(
      String courseId, String docId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .doc(courseId)
          .collection("feedback")
          .doc(docId)
          .collection("replies")
          .orderBy("userTime", descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => FeedBackReplies.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<ForumReplies>> getListofForumRelpies(
      String courseId, String docId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .doc(courseId)
          .collection("forum")
          .doc(docId)
          .collection("replies")
          .orderBy("userTime")
          .snapshots()
          .map((event) =>
              event.docs.map((e) => ForumReplies.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<SingleCourseModel> getCourseById(String courseId) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .doc(courseId)
          .snapshots()
          .map((event) => SingleCourseModel.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<SingleCourseModel> getSingleCoursefromPurchased(
      String userId, String courseId) {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased");

    try {
      return userReference
          .doc(courseId)
          .snapshots()
          .map((event) => SingleCourseModel.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleCourseModel>> getListoCoursefromPurchased(String userId) {
    CollectionReference userReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(userId)
        .collection("purchased");

    try {
      return userReference.snapshots().map((event) =>
          event.docs.map((e) => SingleCourseModel.fromMap(e)).toList());
    } catch (e) {
      return null;
    }
  }

  Stream<List<SingleCourseModel>> getListofCourseBy(String courseType) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");

    try {
      if (courseType == "free") {
        return reference
            .where("coursePrice", isEqualTo: "free")
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((document) {
            return SingleCourseModel.fromMap(document);
          }).toList();
        });
      } else if (courseType == "paid") {
        return reference
            .where("coursePrice", isNotEqualTo: "free")
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((document) {
            return SingleCourseModel.fromMap(document);
          }).toList();
        });
      } else if (courseType == "topEnrolled") {
        return reference.orderBy("enrolledUsers").snapshots().map((snapshot) {
          return snapshot.docs.map((document) {
            return SingleCourseModel.fromMap(document);
          }).toList();
        });
      } else if (courseType == "short") {
        return reference
            .where("totalVideos", isLessThan: 10)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((document) {
            return SingleCourseModel.fromMap(document);
          }).toList();
        });
      } else {
        return reference.snapshots().map((snapshot) {
          return snapshot.docs.map((document) {
            return SingleCourseModel.fromMap(document);
          }).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Stream<List<SingleCourseModel>> getListCoursebyClass(String userClass) {
    CollectionReference reference = firebaseFirestore
        .collection("School")
        .doc("Courses Id")
        .collection("Courses");
    try {
      return reference
          .where("courseClass", isEqualTo: "$userClass")
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((document) {
          return SingleCourseModel.fromMap(document);
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
