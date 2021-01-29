import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/forum_model.dart';
import 'package:merit_coaching_app1/screens/detailScreen/feedback/give_feedback.dart';
import 'package:merit_coaching_app1/screens/forum_screen/forum/give_review.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/rating.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:shimmer/shimmer.dart';

import 'forum_reply.dart';

class ForumModule extends StatefulWidget {
  final SingleForum forum;
  final String courseId;

  const ForumModule({
    Key key,
    this.forum,
    this.courseId,
  }) : super(key: key);
  @override
  _ForumModuleState createState() => _ForumModuleState();
}

class _ForumModuleState extends State<ForumModule> {
  String desc =
      "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat ";
  @override
  void initState() {
    super.initState();
  }

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);
    var logic = Provider.of<FirebaseUserService>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: logic.getSingleUser(widget.forum.userId),
            builder: (context, snapshot) {
              FirebaseAppUser appUser = snapshot.data;
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          height: 30.0,
                          width: 30.0,
                          fit: BoxFit.cover,
                          imageUrl: appUser.userUrl,
                          placeholder: (context, url) => SizedBox(
                            height: 80.0,
                            child: Shimmer.fromColors(
                              baseColor: kWhite,
                              highlightColor: Colors.white24,
                              child: Container(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/userImage.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${appUser.userName ?? "user name"}",
                          style: kGoogleMont.copyWith(
                              fontWeight: FontWeight.bold, color: kBlack),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              "${widget.forum.userFeedback}",
              style: kGoogleNun.copyWith(color: kBlack),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "${dateFormat(widget.forum.userTime)}",
                  style:
                      kGoogleMont.copyWith(color: Colors.grey, fontSize: 12.0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return GiveForum(
                          courseId: widget.courseId,
                          isReply: true,
                          docId: widget.forum.docId,
                        );
                      });
                  // showBottomSheet(
                  //     context: context,
                  //     builder: (context) {
                  //       return GiveForum(
                  //         courseId: widget.courseId,
                  //         isReply: true,
                  //         docId: widget.forum.docId,
                  //       );
                  //     });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "reply",
                    style: kGoogleMont.copyWith(
                        color: Colors.greenAccent, fontSize: 12.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    showAll ? "Show less" : "Show replies",
                    style: kGoogleMont.copyWith(
                        color: Colors.greenAccent, fontSize: 12.0),
                  ),
                ),
              ),
            ],
          ),
          showAll
              ? StreamBuilder(
                  stream: provider.getListofForumRelpies(
                      widget.courseId, widget.forum.docId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ForumReplies> data = snapshot.data;
                      if (data.length == 0) {
                        return Text(
                          "No replies yet",
                          style: kGoogleNun.copyWith(color: kBlack),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ForumReply(
                              forumReply: data[index],
                            );
                          },
                        );
                      }
                    } else {
                      return spinLoader();
                    }
                  })
              : Container()
        ],
      ),
    );
  }
}
