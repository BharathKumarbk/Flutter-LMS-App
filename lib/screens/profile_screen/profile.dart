import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/screens/profile_screen/update_user.dart';
import 'package:merit_coaching_app1/screens/settings_screen/settings.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatelessWidget {
  final int enrolled;
  const Profile({
    Key key,
    this.enrolled,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<FirebaseUserService>(context);

    final user = Provider.of<AuthenticationService>(context);
    return user.userCred.uid != null
        ? StreamBuilder(
            stream: appUser.getSingleUser(user.userCred.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FirebaseAppUser firebaseAppUser = snapshot.data;
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  EvaIcons.settings2,
                                  color: backColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SettingsScreen(
                                            user: firebaseAppUser,
                                          )));
                                },
                              )
                            ],
                          ),
                          ClipOval(
                            child: CachedNetworkImage(
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                              imageUrl: firebaseAppUser.userUrl,
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
                          Container(
                            height: 35.0,
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FittedBox(
                                    child: AutoSizeText(
                                      firebaseAppUser.userName ?? "no name",
                                      style: kGoogleNun.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kBlack),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: AutoSizeText(
                                      firebaseAppUser.userMail ?? "EmailId",
                                      style: kGoogleNun.copyWith(color: kBlack),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60.0,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: accountText(
                                      "$enrolled" ?? "0", "Courses Enrolled"),
                                ),
                                VerticalDivider(),
                                Expanded(
                                  child: accountText(
                                      firebaseAppUser.userClass == ""
                                          ? "0"
                                          : "${firebaseAppUser.userClass}",
                                      "Class"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    (firebaseAppUser.userClass == "0" ||
                            firebaseAppUser.userUrl == "" ||
                            firebaseAppUser.userName == "")
                        ? Container(
                            width: double.infinity,
                            height: 40.0,
                            child: FlatButton(
                                color: Colors.red[300],
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UpdateUser(
                                            isGoogle: firebaseAppUser.isGoogle,
                                            appUser: firebaseAppUser,
                                          )));
                                },
                                child: Text(
                                  "Update your profile",
                                  style: kGoogleNun.copyWith(color: kWhite),
                                )),
                          )
                        : Container()
                  ],
                );
              } else {
                return progressBar();
              }
            },
          )
        : Center(child: progressBar());
  }
}

Widget accountText(String top, String bottom) {
  return Column(
    children: [
      Expanded(
        flex: 4,
        child: FittedBox(
          child: Text(
            "$top",
            style: kGoogleNun.copyWith(
                fontWeight: FontWeight.bold, color: secondaryColor),
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: FittedBox(
          child: Text(
            "$bottom",
            style: kGoogleNun.copyWith(color: kBlack),
          ),
        ),
      ),
    ],
  );
}
