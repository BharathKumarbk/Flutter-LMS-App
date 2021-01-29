
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleCourseModel {
  final String courseName;
  final String courseImageUrl;
  final String coursePrice;
  final String courseRating;
  final String courseClass;
  final String courseSubject;
  final String courseDescription;
  final String language;
  final int enrolled;
  final String curriculumTime;
  final String assessmentTime;
  final List<String> listRating;
  final String courseId;
  final String courseAddedTime;
  final int totalVideos;
  final String totalExams;
  final String totalDocuments;
  final int videosWatched;
  final List<String> favouriteUsers;
  SingleCourseModel({
    this.courseName,
    this.courseImageUrl,
    this.coursePrice,
    this.courseRating,
    this.courseClass,
    this.courseSubject,
    this.courseDescription,
    this.language,
    this.enrolled,
    this.curriculumTime,
    this.assessmentTime,
    this.listRating,
    this.courseId,
    this.courseAddedTime,
    this.totalVideos,
    this.totalExams,
    this.totalDocuments,
    this.videosWatched,
    this.favouriteUsers,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'courseImageUrl': courseImageUrl,
      'coursePrice': coursePrice,
      'courseRating': courseRating,
      'courseClass': courseClass,
      'courseSubject': courseSubject,
      'courseDescription': courseDescription,
      'language': language,
      'enrolledUsers': enrolled,
      'curriculumTime': curriculumTime,
      'assessmentTime': assessmentTime,
      'listRating': listRating,
      'courseId': courseId,
      'courseAddedTime': courseAddedTime,
      'totalVideos': totalVideos,
      'totalExams': totalExams,
      'totalDocuments': totalDocuments,
      'videosWatched': videosWatched,
      'favouriteUsers': favouriteUsers,
    };
  }

  factory SingleCourseModel.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleCourseModel(
      courseName: map.data()['courseName'],
      courseImageUrl: map.data()['courseImageUrl'],
      coursePrice: map.data()['coursePrice'],
      courseRating: map.data()['courseRating'],
      courseClass: map.data()['courseClass'],
      courseSubject: map.data()['courseSubject'],
      courseDescription: map.data()['courseDescription'],
      language: map.data()['language'],
      enrolled: map.data()['enrolledUsers'],
      listRating: List<String>.from(map['listRating']),
      courseId: map.data()['courseId'],
      totalExams: map.data()['totalExams'],
      totalDocuments: map.data()['totalDocuments'],
      curriculumTime: map.data()['curriculumTime'],
      assessmentTime: map.data()['assessmentTime'],
      totalVideos: map.data()['totalVideos'],
      videosWatched: map.data()['videosWatched'],
      courseAddedTime: map.data()['courseAddedTime'],
      favouriteUsers: List<String>.from(map.data()['favouriteUsers']),
    );
  }
}
