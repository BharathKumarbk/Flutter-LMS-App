import 'package:flutter/material.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/screens/forum_screen/forum.dart';

class ForumScreen extends StatefulWidget {
  final String courseId;
  const ForumScreen({
    Key key,
    this.courseId,
  }) : super(key: key);
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backColor,
        title: Text("Forum",style: kGoogleNun,),
        
      ),
      body: ForumList(
        courseId: widget.courseId,
      ),
    );
  }
}
