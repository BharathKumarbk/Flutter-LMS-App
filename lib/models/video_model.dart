import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SingleCurriculumVideo {
  final String videoTitle;
  final String videoUrl;
  final String videoId;
  final String videoTime;
  final String videoSeen;
  final String videoChapter;
  SingleCurriculumVideo({
    this.videoTitle,
    this.videoUrl,
    this.videoId,
    this.videoTime,
    this.videoSeen,
    this.videoChapter,
  });

  Map<String, dynamic> toMap() {
    return {
      'videoTitle': videoTitle,
      'videoUrl': videoUrl,
      'videoId': videoId,
      'videoTime': videoTime,
      'videoSeen': videoSeen,
      'videoChapter': videoChapter,
    };
  }

  factory SingleCurriculumVideo.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleCurriculumVideo(
      videoTitle: map.data()['videoTitle'],
      videoUrl: map.data()['videoUrl'],
      videoId: map.data()['videoId'],
      videoTime: map.data()['videoTime'],
      videoSeen: map.data()['videoSeen'],
      videoChapter: map.data()['videoChapter'],
    );
  }
}

class ProgressModel {
  final int progress;
  ProgressModel({
    this.progress,
  });

  Map<String, dynamic> toMap() {
    return {
      'progress': progress,
    };
  }

  factory ProgressModel.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return ProgressModel(
      progress: map.data()['progress'],
    );
  }
}

class ListChapter {
  final List<String> chapterList;
  ListChapter({
    this.chapterList,
  });

  Map<String, dynamic> toMap() {
    return {
      'chapterList': chapterList,
    };
  }

  factory ListChapter.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return ListChapter(
      chapterList: List<String>.from(map.data()['chapterList']),
    );
  }
}

class SingleCurriculum {
  final String videoId;
  final String chapterNo;
  final String chapterName;
  // final List<SingleVideo> videos;

  SingleCurriculum({
    this.videoId,
    this.chapterNo,
    this.chapterName,
    // this.videos,
  });

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'chapterNo': chapterNo,
      'chapterName': chapterName,
      // 'Videos': videos.map((e) => e.toMap()).toList(),
    };
  }

  factory SingleCurriculum.fromMap(DocumentSnapshot map) {
    if (map == null) return null;
// var list = parsedJson['images'] as List;
// print(list.runtimeType); //returns List<dynamic>
// List<Image> imagesList = list.map((i) => Image.fromJson(i)).toList();

    // var list = map.data()['Videos'] as List;
    // List<SingleVideo> listVideos =
    //     list.map((e) => SingleVideo.fromMap(e)).toList();
    return SingleCurriculum(
      videoId: map.data()['videoId'],
      chapterNo: map.data()['chapterNo'],
      chapterName: map.data()['chapterName'],
      // videos: listVideos,
    );
  }
}

class SingleVideo {
  final String videoTime;
  final String videoUrl;
  final String videoTitle;
  final String videoId;
  final String videoSeen;
  SingleVideo({
    this.videoTime,
    this.videoUrl,
    this.videoTitle,
    this.videoId,
    this.videoSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'videoTime': videoTime,
      'videoUrl': videoUrl,
      'videoTitle': videoTitle,
      'videoId': videoId,
      'videoSeen': videoSeen,
    };
  }

  factory SingleVideo.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return SingleVideo(
      videoTime: map.data()['videoTime'],
      videoUrl: map.data()['videoUrl'],
      videoTitle: map.data()['videoTitle'],
      videoId: map.data()['videoId'],
      videoSeen: map.data()['videoSeen'],
    );
  }
}

class IntroVideo {
  final String videoId;
  final String videoUrl;

  IntroVideo({this.videoId, this.videoUrl});

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'videoUrl': videoUrl,
    };
  }

  factory IntroVideo.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return IntroVideo(
      videoId: map.data()['videoId'],
      videoUrl: map.data()['videoUrl'],
    );
  }
}
