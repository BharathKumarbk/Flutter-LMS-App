import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/screens/detailScreen/feedback/give_feedback.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:provider/provider.dart';

import 'feedbackmodule.dart';

class FeedBackList extends StatefulWidget {
  final String courseId;

  const FeedBackList({Key key, this.courseId}) : super(key: key);

  @override
  _FeedBackListState createState() => _FeedBackListState();
}

class _FeedBackListState extends State<FeedBackList> {
  List<String> ratings;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
            
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: secondaryColor, width: 1.0)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GiveFeedback(
                              courseId: widget.courseId,
                            )));
                  },
                  child: Text(
                    "give feedback ",
                    style: kGoogleMont.copyWith(color: secondaryColor),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: StreamBuilder(
                stream: provider.getListofFeedback(widget.courseId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SingleFeedBack> data = snapshot.data;
                  
                    return data.length == 0
                        ? emptyWidget("No Feedback yet", context)
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FeedBackModule(
                                  feedback: data[index],
                                  courseId: widget.courseId);
                            },
                          );
                  } else {
                    return spinLoader();
                  }
                },
              ))
        ],
      ),
    );
  }
}
