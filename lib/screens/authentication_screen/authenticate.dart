import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/sliverbar.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/login.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/signup.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'forget_password.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool onSignInPage = true;
  bool onForgetPwd = false;

  SharedPreferences logindata;
  bool newuser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: onForgetPwd
          ? "Forget Password"
          : onSignInPage
              ? "Sign In"
              : "Sign Up",
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: onForgetPwd
              ? Column(
                  children: [
                    ForgetPassword(),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            onForgetPwd = !onForgetPwd;
                          });
                        },
                        child: Text("Go to Login page",
                            style: kGoogleNun.copyWith(color: kBlack))),
                  ],
                )
              : onSignInPage
                  ? Column(
                      children: [
                        LoginPage(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                onForgetPwd = !onForgetPwd;
                              });
                            },
                            child: Text("forget Password ?",
                                style: kGoogleNun.copyWith(color: kBlack))),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            "OR",
                            style: kGoogleMont.copyWith(color: kBlack),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create an Account ? ",
                              style: kGoogleNun.copyWith(color: kBlack),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  onSignInPage = !onSignInPage;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(" Sign Up",
                                    style: kGoogleNun.copyWith(
                                        color: secondaryColor)),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: [
                        SignUpPage(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an Account ? ",
                              style: kGoogleNun.copyWith(color: kBlack),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  onSignInPage = !onSignInPage;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(" Sign In",
                                    style: kGoogleNun.copyWith(
                                        color: secondaryColor)),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
    );
  }
}
