import 'package:merit_coaching_app1/components/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:provider/provider.dart';

bool emailValidate(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email);
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String errorMsg;

  final TextEditingController emailId = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

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

  double height = 0.0;
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
    animationController.forward();
    final authProvider = Provider.of<AuthenticationService>(context);
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
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: height,
                          child: Text(
                            errorMsg ?? "",
                            style: kGoogleNun.copyWith(color: Colors.red),
                          ),
                        ),
                        isLoading ? spinLoader() :
                            FlatButton(
                                color: secondaryColor,
                                minWidth: double.infinity,
                                height: 40.0,
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_formState.currentState.validate()) {
                                    authProvider
                                        .resetPassword(emailId.text.trim())
                                        .then((value) {
                                      error(
                                          "A Password reset link has been sent to ${emailId.text}",
                                          context);
                                      setState(() {
                                        emailId.text = "";
                                        isLoading = false;
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: kGoogleNun.copyWith(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold),
                                ))
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
