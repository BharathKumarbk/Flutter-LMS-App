import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';

class GiveFeedback extends StatefulWidget {
  final String courseId;
  final String docId;

  const GiveFeedback({
    Key key,
    this.courseId,
    this.docId,
  }) : super(key: key);
  @override
  _GiveFeedbackState createState() => _GiveFeedbackState();
}

class _GiveFeedbackState extends State<GiveFeedback> {
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
  ) {
    setState(() {
      isAdding = true;
    });
    appUser.getSingleUserData(user.userId).then((value) => providerLogic
            .addFeedback(widget.courseId, value.userName,
                textEditingController.text, rating.toString(), value.userUrl)
            .then((value) async {
          await providerLogic.updateRatings(widget.courseId);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text(
            "Feedback",
            style: kGoogleNun.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        backgroundColor: kWhite,
        body: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: titleText("Rate the Course")),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RatingBar.builder(
                        glowColor: Colors.yellow,
                        glow: false,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.yellow[800],
                        ),
                        updateOnDrag: true,
                        onRatingUpdate: (value) {
                          setState(() {
                            rating = value;
                            print(rating);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: titleText("Give Feedback")),
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
                    controller: textEditingController,
                    decoration: InputDecoration(
                        hintText: "feel free to add your feedback",
                        hintStyle: kGoogleMont.copyWith(color: Colors.grey),
                        fillColor: Colors.indigo[50],
                        filled: true,
                        isDense: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                      child: Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isAdding
                            ? spinLoader()
                            : FlatButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: secondaryColor, width: 1.0)),
                                onPressed: () {
                                  if (_fromKey.currentState.validate()) {
                                    addFeedback(
                                      user,
                                      providerLogic,
                                      appUser,
                                    );
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: kGoogleMont.copyWith(
                                      color: secondaryColor),
                                ),
                              ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
