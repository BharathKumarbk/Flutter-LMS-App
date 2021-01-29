import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';

import '../course_list_item.dart';

class ListCourseGrid extends StatelessWidget {
  final Stream<List<SingleCourseModel>> courseStream;
  final String screen;

  const ListCourseGrid({Key key, this.courseStream, this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: courseStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SingleCourseModel> data = snapshot.data;

          if (data.isNotEmpty) {
            return ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListCourseTile(
                      courseModel: data[index],
                    ));
              },
            );
          } else {
            return Center(child: emptyWidget("$screen is Empty", context));
          }
        } else {
          return progressBar();
        }
      },
    );
  }
}
