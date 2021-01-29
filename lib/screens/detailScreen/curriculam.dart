import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class CourseVideo extends StatefulWidget {
  final String courseId;
  final bool isPurchased;
  const CourseVideo({
    Key key,
    this.courseId,
    this.isPurchased,
  }) : super(key: key);

  @override
  _CourseVideoState createState() => _CourseVideoState();
}

class _CourseVideoState extends State<CourseVideo> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: StreamBuilder(
          stream: provider.getListofChaptersFromCourses(widget.courseId),
          builder: (context, snapshot) {
            ListChapter data = snapshot.data;

            if (snapshot.hasData) {
              if (data.chapterList.length == 0) {
                return Center(
                    child: emptyWidget("No videos posted yet", context));
              } else {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: data.chapterList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            tileColor: Colors.grey[50],
                            dense: true,
                            title: Text(
                              "${data.chapterList[index].capitalize()}",
                              style: kGoogleNun.copyWith(
                                  fontSize: 18.0,
                                  color: kBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              EvaIcons.archive,
                              size: 18.0,
                              color: kBlack,
                            ),
                          ),
                        ),
                        ChapterList(
                          chapterTitle: data.chapterList[index],
                          isPurchased: widget.isPurchased,
                          courseId: widget.courseId,
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              return spinLoader();
            }
          },
        ));
  }
}

class ChapterList extends StatelessWidget {
  final String chapterTitle;
  final String courseId;

  final bool isPurchased;
  const ChapterList({
    Key key,
    this.chapterTitle,
    this.courseId,
    this.isPurchased,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<FirebaseCourseRepo>(context);
    return StreamBuilder(
      stream: repo.getListofVideosFromCourses(courseId, chapterTitle),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SingleCurriculumVideo> data = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  dense: true,
                  title: Text(
                    "${data[index].videoTitle}",
                    style: kGoogleNun.copyWith(fontSize: 18.0, color: kBlack),
                  ),
                  leading: ClipOval(
                    child: Container(
                        color: secondaryColor,
                        child: Icon(Icons.play_arrow, color: kWhite)),
                  ),
                  subtitle: Container(
                    width: 60.0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 14.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Locked",
                            style: kGoogleNun.copyWith(color: kBlack),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return spinLoader();
        }
      },
    );
  }
}
