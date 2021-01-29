import 'package:cached_network_image/cached_network_image.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/forum_model.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ForumReply extends StatelessWidget {
  final ForumReplies forumReply;

  const ForumReply({Key key, this.forumReply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logic = Provider.of<FirebaseUserService>(context);
    return forumReply.userId == null
        ? Text("no replies yet")
        : Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: kBlack,
                            size: 14.0,
                          ),
                        ),
                        StreamBuilder(
                          stream: logic.getSingleUser(forumReply.userId),
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
                                          height: 30.0,
                                          child: Shimmer.fromColors(
                                            baseColor: kWhite,
                                            highlightColor: Colors.white24,
                                            child: Container(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/images/userImage.png"),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${appUser.userName ?? "user name"}",
                                        style: kGoogleMont.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kBlack,
                                        ),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      "${forumReply.userReply}",
                      style: kGoogleNun.copyWith(
                        color: kBlack,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${dateFormat(forumReply.userTime)}',
                      style: kGoogleMont.copyWith(
                          color: Colors.grey, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
