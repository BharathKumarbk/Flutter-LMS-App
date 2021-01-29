import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/home.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/signup.dart';
import 'package:merit_coaching_app1/screens/profile_screen/update_user.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final TextEditingController emailId = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = true;
  bool googleLoading = true;

  void clear({bool pwd = true}) {
    pwd
        ? setState(() {
            emailId.text = "";
            password.text = "";
          })
        : setState(() {
            password.text = "";
          });
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final firebaseUserService = Provider.of<FirebaseUserService>(context);

    var logic = Provider.of<FirebaseCourseLogic>(context);

    animationController.forward();
    final AuthenticationService authProvider =
        Provider.of<AuthenticationService>(context);
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.translationValues(animation.value * width, 0, 0),
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formState,
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
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
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
                        isLoading
                            ? FlatButton(
                                color: secondaryColor,
                                minWidth: double.infinity,
                                height: 40.0,
                                onPressed: () {
                                  if (_formState.currentState.validate()) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    authProvider
                                        .signInUserWithEmailAndPassword(
                                            email: emailId.text.trim(),
                                            password: password.text,
                                            context: context)
                                        .then((value) {
                                      setState(() {
                                        isLoading = true;
                                        password.text = "";
                                        emailId.text = "";
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  "Sign In",
                                  style: kGoogleNun.copyWith(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : spinLoader(),
                        googleLoading
                            ? FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    googleLoading = false;
                                    password.text = "";
                                    emailId.text = "";
                                  });

                                  await authProvider
                                      .signInWithGoogle(context)
                                      .then((value) async {
                                    await firebaseUserService
                                        .getSingleUserData(value)
                                        .then((value) async {
                                      if (value == null) {
                                        await signUpGoogle(firebaseUserService,
                                            authProvider, context, "0", logic);
                                      }
                                      setState(() {
                                        googleLoading = true;
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
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
