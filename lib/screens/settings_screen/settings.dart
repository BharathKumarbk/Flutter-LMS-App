import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:merit_coaching_app1/screens/Info_screen/contact.dart';
import 'package:merit_coaching_app1/screens/Info_screen/privacy_policy.dart';
import 'package:merit_coaching_app1/screens/Info_screen/terms_and_condition.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/screens/profile_screen/update_user.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  final FirebaseAppUser user;
  const SettingsScreen({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoggingOut = false;

  void shareApp() async {
    FlutterShare.share(
        title: "Merit Coaching",
        text:
            "Download the new Merit coaching app and share with your friends. Enjoy learning",
        linkUrl: "www.google.com",
        chooserTitle: "Where do you want to share ?");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationService>(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: backColor,
            elevation: 0.0,
            title: Text(
              "Settings",
              style: kGoogleNun.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView(
                    children: [
                      settingsTile("Edit Profile", Icons.edit, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateUser(
                                  isGoogle: widget.user.isGoogle,
                                  appUser: widget.user,
                                )));
                      }),
                      settingsTile("Share app", Icons.share, () {
                        shareApp();
                      }),
                      settingsTile("Privacy policy", Icons.policy, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivacyPolicy()));
                      }),
                      settingsTile("Terms & Condition", EvaIcons.shield, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TermsAndCondition()));
                      }),
                      settingsTile("Contact us", Icons.contact_mail, () {
                        showDialog(
                            context: context,
                            child: Dialog(
                              child: ContactUs(),
                            ));
                      }),
                      // settingsTile("About us", Icons.info, () {}),
                      // settingsTile("Delete account", Icons.delete_forever,
                      //     () async {
                      //   setState(() {
                      //     isLoggingOut = true;
                      //   });
                      //   if (isLoggingOut == true) {
                      //     showDialog(
                      //       barrierDismissible: false,
                      //       context: context,
                      //       child: Dialog(
                      //         child: Container(
                      //           height: 100.0,
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               spinLoader(),
                      //               SizedBox(
                      //                 width: 20.0,
                      //               ),
                      //               Text(
                      //                 "Deleting Account",
                      //                 style: kGoogleNun.copyWith(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   }
                      //   Navigator.pop(context);
                      //   await userService
                      //       .deleteAccount(repo, user, context)
                      //       .then((value) {
                      //     setState(() {
                      //       isLoggingOut = false;
                      //     });
                      //   });
                      // }),
                      settingsTile("Log out", Icons.logout, () async {
                        await user
                            .signOutUser(user.userCred.uid, context)
                            .then((value) => Navigator.pop(context));
                      }),
                      settingsTile("Licenses and more", Icons.library_books,
                          () {
                        showAboutDialog(
                            context: context,
                            applicationName: "Merit Coaching",
                            applicationVersion: "1.0.0",
                            applicationIcon: Container(
                                height: 30.0,
                                width: 30.0,
                                child: Image.asset(
                                    "assets/images/meritLogo.png")));
                      }),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Widget settingsTile(String title, IconData icon, Function onTap) {
  return ListTile(
    title: Text(
      "$title",
      style: kGoogleNun.copyWith(color: kBlack),
    ),
    leading: ClipOval(
      child: Container(
          height: 30.0,
          width: 30.0,
          color: secondaryColor,
          child: Icon(icon, size: 15.0, color: kWhite)),
    ),
    onTap: onTap,
  );
}
