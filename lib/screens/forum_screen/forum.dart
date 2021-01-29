import 'package:cached_network_image/cached_network_image.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/models/forum_model.dart';
import 'package:merit_coaching_app1/screens/detailScreen/feedback/give_feedback.dart';
import 'package:merit_coaching_app1/screens/forum_screen/forum/give_review.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'forum/forum_single.dart';

class ForumList extends StatefulWidget {
  final String courseId;

  const ForumList({Key key, this.courseId}) : super(key: key);

  @override
  _ForumListState createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  List<String> ratings;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);
    final user = Provider.of<AuthenticationService>(context);
    var service = Provider.of<FirebaseUserService>(context);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Color(0xff30475e),
        title: StreamBuilder(
          stream: service.getSingleUser(user.userCred.uid),
          builder: (context, snapshot) {
            FirebaseAppUser appUser = snapshot.data;
            if (snapshot.hasData) {
              return Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                      imageUrl: appUser.userUrl,
                      placeholder: (context, url) => SizedBox(
                        height: 40.0,
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
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${appUser.userName}",
                        style: kGoogleNun.copyWith(
                            color: kWhite,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${appUser.userMail}",
                        style:
                            kGoogleNun.copyWith(color: kWhite, fontSize: 12.0),
                      )
                    ],
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return GiveForum(
                      courseId: widget.courseId,
                      isReply: false,
                    );
                  });
            },
            icon: Icon(
              Icons.send,
              color: kWhite,
            ),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: provider.getListofForum(widget.courseId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SingleForum> data = snapshot.data;
              return data.length == 0
                  ? Center(child: emptyWidget("No Post yet", context))
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: kBlack.withOpacity(0.2),
                        );
                      },
                      itemCount: data.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ForumModule(
                            forum: data[index], courseId: widget.courseId);
                      },
                    );
            } else {
              return spinLoader();
            }
          },
        ),
      ),
    );
  }
}
