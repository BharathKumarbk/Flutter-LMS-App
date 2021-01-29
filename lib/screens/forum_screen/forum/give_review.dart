import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';

class GiveForum extends StatefulWidget {
  final String courseId;
  final String docId;
  final bool isReply;

  const GiveForum({
    Key key,
    this.courseId,
    this.docId,
    this.isReply,
  }) : super(key: key);
  @override
  _GiveForumState createState() => _GiveForumState();
}

class _GiveForumState extends State<GiveForum> {
  GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  bool isAdding = false;
  double rating = 0.0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  addFeedback(
    AppUser user,
    FirebaseCourseLogic providerLogic,
    FirebaseUserService appUser,
    bool isReply,
  ) async {
    setState(() {
      isAdding = true;
    });
    await appUser.getSingleUserData(user.userId).then((value) => isReply
        ? providerLogic
            .addForumReply(widget.courseId, value.userId,
                textEditingController.text, widget.docId)
            .then((value) {
            setState(() {
              isAdding = false;
              textEditingController.text = "";
            });
            Navigator.pop(context);
          })
        : providerLogic
            .addForum(
            widget.courseId,
            value.userId,
            textEditingController.text,
          )
            .then((value) {
            setState(() {
              isAdding = false;
              textEditingController.text = "";
            });
            Navigator.pop(context);
          }));
  }

  @override
  Widget build(BuildContext context) {
    final providerLogic = Provider.of<FirebaseCourseLogic>(context);
    final user = Provider.of<AppUser>(context);
    final appUser = Provider.of<FirebaseUserService>(context);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: kBlack,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: titleText(widget.isReply ? "Reply" : "Post"),
                    ),
                    Spacer(),
                    isAdding
                        ? spinLoader()
                        : FlatButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: secondaryColor,
                              width: 1.0
                            )
                          ),
                            onPressed: () {
                              if (_fromKey.currentState.validate()) {
                                widget.isReply
                                    ? addFeedback(user, providerLogic,
                                        appUser, widget.isReply)
                                    : addFeedback(user, providerLogic,
                                        appUser, widget.isReply);
                              }
                            },
                            child: Text(
                              "Post",
                              style: kGoogleMont.copyWith(color: secondaryColor),
                            ),
                          ),
                  ],
                ),
              ),
              TextFormField(
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Field should not be empty";
                  } else {
                    return null;
                  }
                },
                autofocus: true,
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "your thoughts",
                    hintStyle: kGoogleMont.copyWith(color: Colors.grey),
                    fillColor: Colors.indigo[50],
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
