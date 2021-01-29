import 'package:merit_coaching_app1/components/course_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/course.dart';

class CourseGridHorizontalList extends StatefulWidget {
  final List<SingleCourseModel> course;

  const CourseGridHorizontalList({Key key, this.course}) : super(key: key);

  @override
  _CourseGridHorizontalListState createState() =>
      _CourseGridHorizontalListState();
}

class _CourseGridHorizontalListState extends State<CourseGridHorizontalList> {
  List<SingleCourseModel> courseModel = [];
  @override
  void initState() {
    courseModel = getListofCourse(widget.course);
    super.initState();
  }

  List<SingleCourseModel> getListofCourse(List<SingleCourseModel> course) {
    if (course.length < 10) {
      return course.sublist(0, course.length);
    } else {
      return course.sublist(0, 11);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 150.0, maxHeight: 180.0),
      child: Container(
        child: courseModel.length == 0
            ? Center(child: emptyWidget("No Courses found", context))
            : ListView.builder(
                itemCount: courseModel.length,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CourseGridTiles(
                      course: courseModel[index],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
