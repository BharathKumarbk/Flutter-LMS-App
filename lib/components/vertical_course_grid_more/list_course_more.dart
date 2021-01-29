import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';

import 'package:merit_coaching_app1/components/course_grid_item.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/components/vertical_course_grid/listCousreGrid.dart';

import 'package:merit_coaching_app1/models/course.dart';

import '../course_list_item.dart';

class ListCourseMore extends StatelessWidget {
  final String title;
  final List<SingleCourseModel> courseStream;

  const ListCourseMore({
    Key key,
    this.title,
    this.courseStream,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: backColor,
          title: Text(
            title,
            style: kGoogleNun.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: courseStream.isEmpty
            ? Center(child: emptyWidget("$title is Empty", context))
            : ListView.builder(
                itemCount: courseStream.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListCourseTile(
                        courseModel: courseStream[index],
                      ));
                },
              ));
  }
}
