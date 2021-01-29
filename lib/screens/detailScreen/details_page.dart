import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merit_coaching_app1/components/videoPlayer/video_player.dart';
import 'package:merit_coaching_app1/models/video_model.dart';
import 'package:merit_coaching_app1/screens/detailScreen/forumScreen.dart';
import 'package:provider/provider.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/detailScreen/curriculam.dart';
import 'package:merit_coaching_app1/screens/detailScreen/overview.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import 'feedback/feedback.dart';

class DetailsPage extends StatefulWidget {
  final SingleCourseModel course;

  const DetailsPage({
    Key key,
    this.course,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  bool isPurchased;

  @override
  Widget build(BuildContext context) {
    var courseRepo = Provider.of<FirebaseCourseRepo>(context);
    final appUser = Provider.of<AuthenticationService>(context);
    return Scaffold(
        backgroundColor: kWhite,
        body: StreamBuilder(
          stream: courseRepo.getSingleCoursefromPurchased(
              appUser.userCred.uid, widget.course.courseId),
          builder: (context, snapshot) {
            SingleCourseModel courseData = snapshot.data;
            if (snapshot.hasData) {
              if (courseData.courseId == widget.course.courseId) {
                return DetailsScreen(
                  course: widget.course,
                  isPurchased: true,
                );
              } else {
                return DetailsScreen(
                  course: widget.course,
                  isPurchased: false,
                  // assessTime: courseData.assessmentTime,
                  // currTime: courseData.curriculumTime,
                );
              }
            } else {
              // return spinLoader();
              return DetailsScreen(
                course: widget.course,
                isPurchased: false,
                // assessTime: courseData.assessmentTime,
                // currTime: courseData.curriculumTime,
              );
            }
          },
        ));
  }
}

class DetailsScreen extends StatefulWidget {
  final SingleCourseModel course;
  final bool isPurchased;

  const DetailsScreen({
    Key key,
    this.course,
    this.isPurchased,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavourite = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var courseRepo = Provider.of<FirebaseCourseRepo>(context);
    final appUser = Provider.of<AuthenticationService>(context);
    final user = Provider.of<AppUser>(context);
    final provider = Provider.of<FirebaseCourseLogic>(context);

    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: backColor,
                        elevation: 0.0,
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: true,
                        actions: [
                          FlatButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ForumScreen(
                                          courseId: widget.course.courseId,
                                        )));
                              },
                              icon: Icon(
                                Icons.forum,
                                color: kWhite,
                              ),
                              label: Text(
                                "Go to Forum",
                                style: kGoogleNun.copyWith(color: kWhite),
                              ))
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.course.courseImageUrl,
                                    placeholder: (context, url) => SizedBox(
                                      height: 80.0,
                                      child: Shimmer.fromColors(
                                        baseColor: kWhite,
                                        highlightColor: Colors.white24,
                                        child: Container(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/noimage.png"),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.black45,
                                ),
                                Column(
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Row(
                                        children: [
                                          StreamBuilder(
                                            stream: courseRepo.getIntroVideo(
                                                widget.course.courseId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              IntroVideo introVideo =
                                                  snapshot.data;
                                              if (snapshot.hasData) {
                                                return FloatingActionButton(
                                                  heroTag: "playButton",
                                                  backgroundColor:
                                                      secondaryColor,
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChewieListItem(
                                                                  videotitle:
                                                                      "Course Intro",
                                                                  videoPlayerController:
                                                                      VideoPlayerController.network(
                                                                          introVideo
                                                                              .videoUrl),
                                                                )));
                                                  },
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else {
                                                return FloatingActionButton(
                                                  heroTag: "playButton",
                                                  backgroundColor:
                                                      secondaryColor,
                                                  onPressed: () {},
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                    widget.isPurchased
                                                        ? "Purchased"
                                                        : priceText(widget
                                                            .course
                                                            .coursePrice),
                                                    style: kGoogleNun.copyWith(
                                                      fontSize: 20.0,
                                                      color: kWhite,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  RatingBarIndicator(
                                                    rating: double.parse(
                                                      double.parse(widget.course
                                                                  .courseRating)
                                                              .isNaN
                                                          ? "0.0"
                                                          : widget.course
                                                              .courseRating,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[800],
                                                    ),
                                                    unratedColor: kWhite,
                                                    itemCount: 5,
                                                    itemSize: 18.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                      double.parse(widget.course
                                                                  .courseRating)
                                                              .isNaN
                                                          ? "0.0"
                                                          : widget.course
                                                              .courseRating,
                                                      style:
                                                          kGoogleNun.copyWith(
                                                              fontSize: 18.0,
                                                              color: kWhite))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            labelColor: secondaryColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            indicatorPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(icon: SizedBox.shrink(), text: "Overview"),
                              Tab(icon: SizedBox.shrink(), text: "Curriculam"),
                              Tab(icon: SizedBox.shrink(), text: "FeedBack"),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(children: [
                    OverView(
                      course: widget.course,
                      isPurchased: widget.isPurchased,
                      firebaseCourseRepo: courseRepo,
                      appUser: user,
                      authenticationService: appUser,
                    ),
                    CourseVideo(
                      courseId: widget.course.courseId,
                      isPurchased: widget.isPurchased,
                    ),
                    FeedBackList(
                      courseId: widget.course.courseId,
                    ),
                  ])),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kWhite,
        child: StreamBuilder(
          stream: courseRepo.getCourseById(widget.course.courseId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SingleCourseModel data = snapshot.data;
              if (data.favouriteUsers.contains(appUser.userCred.uid)) {
                isAdded = false;
                return Icon(EvaIcons.heart,color: secondaryColor,);
              } else {
                isAdded = true;
                return Icon(EvaIcons.heartOutline);
              }
            } else {
              isAdded = true;
              return Icon(EvaIcons.heartOutline);
            }
          },
        ),
        onPressed: () async {
          isAdded
              ? Fluttertoast.showToast(msg: "Course added to your favourites")
              : Fluttertoast.showToast(msg: "Course removed from your favourites");
          await provider.saveToFavourites(
              appUser.userCred.uid, widget.course.courseId);
        },
      ),
    );
  }

  bool isAdded;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: kWhite,
      height: 80.0,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
