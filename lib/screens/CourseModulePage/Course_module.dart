import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/screens/forum_screen/forum.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'course_assesments.dart';
import 'course_attachments.dart';
import 'course_videos.dart';

class CourseModule extends StatefulWidget {
  final String courseId;
  final String userId;
  const CourseModule({
    Key key,
    this.courseId,
    this.userId,
  }) : super(key: key);
  @override
  _CourseModuleState createState() => _CourseModuleState();
}

class _CourseModuleState extends State<CourseModule> {
  @override
  Widget build(BuildContext context) {
    var repo = Provider.of<FirebaseCourseRepo>(context);
    var logic = Provider.of<FirebaseCourseLogic>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: backColor,
            child: new SafeArea(
              child: TabBar(
                isScrollable: true,
                labelColor: secondaryColor,
                unselectedLabelColor: kWhite,
                labelStyle: kGoogleNun,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: "Videos",
                  ),
                  Tab(
                    text: "Assesment",
                  ),
                  Tab(
                    text: "Attachments",
                  ),
                  Tab(
                    text: "Forum",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
                future: logic.getRecentVideoId(
                  widget.userId,
                ),
                builder: (context, snapshot) {
                  String videoId = snapshot.data;
                  if (snapshot.hasData) {
                    return StreamBuilder(
                        stream: logic.getRecentVideo(
                            widget.userId, widget.courseId, videoId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          SingleCurriculumVideo singleVideo = snapshot.data;
                          if (snapshot.hasData) {
                            return CoursePlayVideo(
                              courseId: widget.courseId,
                              userId: widget.userId,
                              repo: repo,
                              singleVideo: singleVideo,
                              url: VideoPlayerController.network(
                                  singleVideo.videoUrl),
                            );
                          } else {
                            return spinLoader();
                          }
                        });
                  } else {
                    return spinLoader();
                  }
                }),
            CourseAssesment(
              courseId: widget.courseId,
              userId: widget.userId,
            ),
            CourseAttachment(
              courseId: widget.courseId,
              userId: widget.userId,
            ),
            ForumList(
              courseId: widget.courseId,
            )
          ],
        ),
      ),
    );
  }
}
