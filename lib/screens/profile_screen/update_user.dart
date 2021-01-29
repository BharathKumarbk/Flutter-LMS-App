import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';

class UpdateUser extends StatefulWidget {
  final bool isGoogle;
  final FirebaseAppUser appUser;
  const UpdateUser({
    Key key,
    this.isGoogle,
    this.appUser,
  }) : super(key: key);
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController userClass = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  File image;
  final picker = ImagePicker();
  bool isSignedIn = true;
  double height = 0.0;
  String errorMsg = "";

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        error("No Image Selected", context);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        error("No Image Selected", context);
      }
    });
  }

  @override
  void initState() {
    userName.text = widget.appUser.userName;
    userClass.text = widget.appUser.userClass;

    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    userClass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationService>(context);
    final logic = Provider.of<FirebaseCourseLogic>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Update account",
            style: kGoogleNun,
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => Navigator.pop(context),
            )
          ],
          centerTitle: true,
          backgroundColor: backColor,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.isGoogle
                        ? Container()
                        : Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: new DecorationImage(
                                    image: image != null
                                        ? FileImage(image)
                                        : widget.appUser.userUrl != ""
                                            ? NetworkImage(
                                                widget.appUser.userUrl)
                                            : AssetImage(
                                                "assets/images/userImage.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(100.0)),
                                  border: new Border.all(
                                    color: secondaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      color: tealColor,
                                      icon: Icon(Icons.image),
                                      onPressed: () {
                                        getImageFromGallery();
                                      }),
                                  IconButton(
                                      color: tealColor,
                                      icon: Icon(Icons.camera),
                                      onPressed: () {
                                        getImageFromCamera();
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "User name",
                                      style: kGoogleNun.copyWith(color: kBlack),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: userName,
                                    maxLength: 30,
                                    validator: (value) {
                                      if (value == "no name") {
                                        return "Please specify a valid name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        counterStyle:
                                            kGoogleMont.copyWith(color: kBlack),
                                        hintText: "Type your name here",
                                        prefixIcon: Icon(
                                          EvaIcons.personOutline,
                                          size: 24.0,
                                        ),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Colors.indigo[50],
                                        focusColor: secondaryColor,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Class",
                        style: kGoogleNun.copyWith(color: kBlack),
                      ),
                    ),
                    TextFormField(
                      controller: userClass,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (int.parse(value) > 12) {
                          return "Class should not be above 12";
                        } else if (int.parse(value) < 1) {
                          return "Class should not be below 0";
                        } else if (value.isEmpty) {
                          return "Field should not be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Which class are you in ?",
                          prefixIcon: Icon(
                            Icons.leaderboard,
                            size: 24.0,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.indigo[50],
                          focusColor: secondaryColor,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
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
                    Text(errorMsg),
                    isSignedIn
                        ? widget.isGoogle
                            ? FlatButton(
                                color: secondaryColor,
                                minWidth: double.infinity,
                                height: 40.0,
                                onPressed: () async {
                                  if (_formState.currentState.validate()) {
                                    setState(() {
                                      isSignedIn = false;
                                    });
                                    await logic.updateUser(
                                      widget.isGoogle,
                                      authProvider.userCred.uid,
                                      userClass: userClass.text,
                                    );
                                    setState(() {
                                      isSignedIn = true;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  "Update",
                                  style: kGoogleNun.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                            : FlatButton(
                                color: secondaryColor,
                                minWidth: double.infinity,
                                height: 40.0,
                                onPressed: () async {
                                  if (_formState.currentState.validate()) {
                                    setState(() {
                                      isSignedIn = false;
                                    });

                                    if (image != null ||
                                        widget.appUser.userUrl != "") {
                                      await logic
                                          .updateUser(
                                        widget.isGoogle,
                                        authProvider.userCred.uid,
                                        url: widget.appUser.userUrl,
                                        image: image,
                                        userName: userName.text,
                                        userClass: userClass.text,
                                      )
                                          .then((value) {
                                        setState(() {
                                          isSignedIn = true;
                                        });
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      error("No image selected", context);
                                      setState(() {
                                        isSignedIn = true;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  "Update",
                                  style: kGoogleNun.copyWith(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold),
                                ))
                        : spinLoader(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
