import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merit_coaching_app1/screens/detailScreen/feedback/give_feedback.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/rating.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/feedback_model.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:shimmer/shimmer.dart';

class FeedBackModule extends StatefulWidget {
  final SingleFeedBack feedback;
  final String courseId;

  const FeedBackModule({
    Key key,
    this.feedback,
    this.courseId,
  }) : super(key: key);
  @override
  _FeedBackModuleState createState() => _FeedBackModuleState();
}

class _FeedBackModuleState extends State<FeedBackModule> {
  String desc =
      "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat ";
  @override
  void initState() {
    super.initState();
  }

  onTapShowDialog() {
    return showDialog(
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    maxLines: null,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "feel free to add your feedback",
                        hintStyle: kGoogleMont.copyWith(color: Colors.grey),
                        fillColor: kWhite,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.greenAccent,
                    child: Text(
                      "Submit",
                      style: kGoogleMont,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseCourseRepo>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    child: widget.feedback.userImage.isEmpty
                        ? Image(
                            image: AssetImage("assets/images/userImage.png"))
                        : Image(
                            image:
                                NetworkImage("${widget.feedback.userImage}")),
                  ),
                ),
                // ClipOval(
                //   child: widget.feedback.userImage != null
                //       ? CachedNetworkImage(
                //           height: 30.0,
                //           width: 30.0,
                //           fit: BoxFit.cover,
                //           imageUrl: widget.feedback.userImage,
                //           placeholder: (context, url) => SizedBox(
                //             height: 30.0,
                //             child: Shimmer.fromColors(
                //               baseColor: kWhite,
                //               highlightColor: Colors.white24,
                //               child: Container(),
                //             ),
                //           ),
                //           errorWidget: (context, url, error) =>
                //               Image.asset("assets/images/userImage.png"),
                //         )
                //       : Container(),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.feedback.userName ?? "user name"}",
                    style: kGoogleMont.copyWith(
                        fontWeight: FontWeight.bold, color: kBlack),
                  ),
                ),
                RatingStar(
                  value: "${widget.feedback.userRating}",
                  size: 16.0,
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              "${widget.feedback.userFeedback}",
              style: kGoogleNun.copyWith(color: kBlack),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "${dateFormat(widget.feedback.userTime)}",
              style: kGoogleMont.copyWith(color: Colors.grey, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
