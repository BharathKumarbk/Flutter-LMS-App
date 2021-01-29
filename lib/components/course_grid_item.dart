import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/rating.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/detailScreen/details_page.dart';
import 'package:flutter/material.dart';


import 'package:shimmer/shimmer.dart';

class CourseGridTiles extends StatefulWidget {
  final SingleCourseModel course;

  const CourseGridTiles({Key key, this.course}) : super(key: key);

  @override
  _CourseGridTilesState createState() => _CourseGridTilesState();
}

class _CourseGridTilesState extends State<CourseGridTiles> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180.0,
        decoration: BoxDecoration(
          color: kWhite,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.course.courseImageUrl,
                      placeholder: (context, url) => SizedBox(
                        height: 80.0,
                        child: Shimmer.fromColors(
                          baseColor: kWhite,
                          highlightColor: Colors.white24,
                          child: Container(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/noimage.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: AutoSizeText(
                      "${widget.course.courseName.capitalize()} ${widget.course.courseName} ",
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 12.0,
                      maxFontSize: 24.0,
                      maxLines: 3,
                      style: kGoogleNun.copyWith(
                        color: kBlack,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  height: 30.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(priceText(widget.course.coursePrice),
                              style: kGoogleNun.copyWith(
                                fontWeight: FontWeight.bold,
                                color: tealColor,
                              )),
                          RatingStar(
                            value:
                                double.parse(widget.course.courseRating).isNaN
                                    ? "0.0"
                                    : widget.course.courseRating,
                            size: 12.0,
                          ),
                        ],
                      )),
                )
              ],
            ),
            Container(
              width: 180.0,
              height: 180.0,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(10.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPage(
                              course: widget.course,
                            )));
                  },
                  child: Container(),
                ),
              ),
            ),
          ],
        ));
  }
}
