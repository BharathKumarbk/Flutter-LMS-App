import 'package:chewie/chewie.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class CoursePlayVideo extends StatefulWidget {
  final String courseId;
  final bool isPurchased;
  final VideoPlayerController url;
  final String userId;
  final FirebaseCourseRepo repo;
  final SingleCurriculumVideo singleVideo;
  const CoursePlayVideo({
    Key key,
    this.courseId,
    this.isPurchased,
    this.url,
    this.userId,
    this.repo,
    this.singleVideo,
  }) : super(key: key);

  @override
  _CoursePlayVideoState createState() => _CoursePlayVideoState();
}

class _CoursePlayVideoState extends State<CoursePlayVideo>
    with AutomaticKeepAliveClientMixin {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  void checkVideo(VideoPlayerController videoPlayerController,
      SingleCurriculumVideo video) async {
    if (videoPlayerController.value.position ==
        videoPlayerController.value.duration) {
      debugPrint(video.videoSeen);
      if (video.videoSeen == "false") {
        await widget.repo.updateVideoSeen(
          widget.courseId,
          widget.userId,
          video.videoId,
        );
        await widget.repo.updateVideoNum(widget.courseId, widget.userId);
      }
    }
  }

  bool isVideoLoading = false;
  bool isSelected = true;

  @override
  void initState() {
    super.initState();
    selected = widget.singleVideo.videoId;
    initVideo(
        isWatched: widget.singleVideo.videoSeen,
        videoId: widget.singleVideo.videoId,
        firebaseCourseRepo: widget.repo,
        video: widget.singleVideo);
    // Wrapper on top of the videoPlayerController
  }

  playVideo() async {}

  String selected;

  initVideo(
      {String isWatched,
      FirebaseCourseRepo firebaseCourseRepo,
      String videoId,
      SingleCurriculumVideo video}) {
    _videoPlayerController = VideoPlayerController.network(video.videoUrl);
    _videoPlayerController.addListener(() {
      checkVideo(_videoPlayerController, video);
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.pause();
    _chewieController.pause();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);
    final logic = Provider.of<FirebaseCourseLogic>(context);

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StreamBuilder(
                stream: provider.getListofChaptersFromUsers(
                    widget.courseId, widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ListChapter data = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
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
                                      fontWeight: FontWeight.bold,
                                      color: kBlack),
                                ),
                                leading: Icon(
                                  EvaIcons.archive,
                                  size: 18.0,
                                  color: kBlack,
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: provider.getListofVideosFromUsers(
                                  widget.courseId,
                                  data.chapterList[index],
                                  widget.userId),
                              builder: (context, snapshot) {
                                List<SingleCurriculumVideo> data =
                                    snapshot.data;

                                if (snapshot.hasData) {
                                  if (data.length == 0) {
                                    return emptyWidget(
                                        "No videos posted", context);
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          dense: true,
                                          tileColor:
                                              selected == data[index].videoId
                                                  ? backColor
                                                  : Colors.white,
                                          title: Text(
                                            "${data[index].videoTitle}",
                                            style: kGoogleNun.copyWith(
                                                fontSize: 18.0,
                                                color: selected ==
                                                        data[index].videoId
                                                    ? kWhite
                                                    : kBlack),
                                          ),
                                          leading: ClipOval(
                                            child: Container(
                                                color: secondaryColor,
                                                child: Icon(Icons.play_arrow,
                                                    color: kWhite)),
                                          ),
                                          onTap: () async {
                                            _videoPlayerController.pause();
                                            _videoPlayerController.initialize();
                                            initVideo(
                                              video: data[index],
                                              videoId: data[index].videoId,
                                              firebaseCourseRepo: provider,
                                            );
                                            selected = data[index].videoId;

                                            setState(() {});
                                            await logic.setRecentVideoId(
                                                widget.userId,
                                                widget.courseId,
                                                data[index].videoId);
                                          },
                                          subtitle: data[index].videoSeen ==
                                                  "false"
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.grey,
                                                      size: 14.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                        "Not Watched",
                                                        style:
                                                            kGoogleNun.copyWith(
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Icon(
                                                      Icons.visibility,
                                                      color: secondaryColor,
                                                      size: 14.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                        "Watched",
                                                        style: kGoogleNun.copyWith(
                                                            color:
                                                                secondaryColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  return spinLoader();
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return spinLoader();
                  }
                },
              )),
        ),
      ],
    );
  }
}
