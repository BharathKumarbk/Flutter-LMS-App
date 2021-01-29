import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/rating.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';
import 'package:merit_coaching_app1/screens/detailScreen/details_page.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';


class ListCourseTile extends StatelessWidget {
  final SingleCourseModel courseModel;

  const ListCourseTile({
    Key key,
    this.courseModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: kWhite),
      child: new Material(
        child: new InkWell(
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsPage(
                      course: courseModel,
                    )));
          },
          child: Container(
            height: 65.0,
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 65.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: courseModel.courseImageUrl,
                      placeholder: (context, url) => SizedBox(
                        height: 60.0,
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
                )),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "${courseModel.courseName.capitalize()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: kGoogleNun.copyWith(
                                // fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: kBlack.withOpacity(0.8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(priceText(courseModel.coursePrice),
                                style: kGoogleNun.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: tealColor,
                                )),
                            RatingStar(
                              value:
                                  double.parse(courseModel.courseRating).isNaN
                                      ? "0.0"
                                      : courseModel.courseRating,
                              size: 12.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
