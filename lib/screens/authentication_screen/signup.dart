import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

signUpGoogle(
    FirebaseUserService firebaseUserService,
    AuthenticationService authenticationService,
    context,
    String userClass,
    FirebaseCourseLogic logic) async {
  debugPrint("outside method");
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return null;
  }

  firebaseUserService
      .addUser(
          FirebaseAppUser(
            userId: user.uid,
            userName: user.displayName,
            userMail: user.email,
            userClass: userClass,
            userUrl: user.photoURL,
            enrolled: 0,
            isGoogle: true,
            userVideoId: "",
            firstUser: "true",
          ),
          user.uid,
          logic)
      .then((value) {});
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final GlobalKey<FormState> _formStateSignUp = GlobalKey<FormState>();

  final TextEditingController emailId = TextEditingController();

  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isSignedIn = true;
  bool logged = true;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        curve: Curves.fastOutSlowIn, parent: animationController));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailId.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();
    final authProvider = Provider.of<AuthenticationService>(context);
    var userService = Provider.of<FirebaseUserService>(context);
    var logic = Provider.of<FirebaseCourseLogic>(context);

    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.translationValues(animation.value * width, 0, 0),
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formStateSignUp,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: emailId,
                          validator: (value) {
                            if (!emailValidate(value.trim())) {
                              return "Please provide valid email";
                            } else if (value.length < 5) {
                              return "password is too small ( Minimum 6 characters required )";
                            } else if (value.isEmpty) {
                              return "Field should not be empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "E-mail id",
                            prefixIcon: Icon(
                              EvaIcons.emailOutline,
                              size: 24.0,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.indigo[50],
                            focusColor: secondaryColor,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Field should not be empty";
                            } else if (value.length < 5) {
                              return "password is too small ( Minimum 6 characters required )";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(
                                EvaIcons.lockOutline,
                                size: 24.0,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.indigo[50],
                              focusColor: secondaryColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: confirmPassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Field should not be empty";
                            } else if (value.length < 5) {
                              return "password is too small ( Minimum 6 characters required )";
                            } else if (password.text != confirmPassword.text) {
                              return "Passwords did not match";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Confrim Password",
                              prefixIcon: Icon(
                                EvaIcons.lockOutline,
                                size: 24.0,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.indigo[50],
                              focusColor: secondaryColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        isSignedIn
                            ? FlatButton(
                                color: secondaryColor,
                                minWidth: double.infinity,
                                height: 40.0,
                                onPressed: () async {
                                  if (_formStateSignUp.currentState
                                      .validate()) {
                                    setState(() {
                                      isSignedIn = false;
                                    });
                                    authProvider
                                        .createWithEmailAndPassword(
                                            email: emailId.text.trim(),
                                            password: confirmPassword.text,
                                            context: context)
                                        .then((value) async {
                                      await userService.addUser(
                                          FirebaseAppUser(
                                            userId: value.user.uid,
                                            userMail: emailId.text,
                                            userClass: "",
                                            userName: "no name",
                                            userUrl: "",
                                            isGoogle: false,
                                            userVideoId: "",
                                            firstUser: "true",
                                          ),
                                          value.user.uid,
                                          logic);
                                    }).catchError((onError) {
                                      setState(() {
                                        isSignedIn = true;
                                        password.text = "";
                                        emailId.text = "";
                                        confirmPassword.text = "";
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  "Sign Up",
                                  style: kGoogleNun.copyWith(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold),
                                ))
                            : spinLoader(),
                        logged
                            ? FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    logged = false;
                                  });
                                  await authProvider
                                      .signInWithGoogle(context)
                                      .then((value) async {
                                    await userService
                                        .getSingleUserData(value)
                                        .then((value) async {
                                      if (value == null) {
                                        await signUpGoogle(userService,
                                            authProvider, context, "0", logic);
                                      }
                                      setState(() {
                                        logged = true;
                                      });
                                    });
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: kBlack,
                                      width: 0.5,
                                      style: BorderStyle.solid),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 20.0,
                                        child: Image.asset(
                                            "assets/images/google.png")),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "Sign In with Google",
                                      style: kGoogleNun.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kBlack),
                                    )
                                  ],
                                ))
                            : spinLoader(),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            "OR",
                            style: kGoogleMont.copyWith(color: kBlack),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
