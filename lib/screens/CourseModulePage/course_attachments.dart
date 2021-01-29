import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/attach_doc_model.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class CourseAttachment extends StatelessWidget {
  final String courseId;
  final String userId;
  const CourseAttachment({
    Key key,
    this.courseId,
    this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FirebaseCourseRepo>(context);
    return StreamBuilder(
      stream: provider.getListAttachmentsforPurchased(courseId, userId),
      builder: (context, snapshot) {
        List<AttachDoc> attach = snapshot.data;
        if (snapshot.hasData) {
          if (attach.length == 0) {
            return emptyWidget("No Attachments posted", context);
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: attach.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${attach[index].docTitle}",
                    style: kGoogleNun.copyWith(fontSize: 18.0, color: kBlack),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttachmentViewer(
                              url: attach[index].docUrl,
                            )));
                  },
                  leading: ClipOval(
                      child: Container(
                    height: 40.0,
                    width: 40.0,
                    color: secondaryColor,
                    child: Icon(
                      Icons.attach_file,
                      color: kWhite,
                    ),
                  )),
                );
              },
            );
          }
        } else {
          return spinLoader();
        }
      },
    );
  }
}

class AttachmentViewer extends StatefulWidget {
  final String url;
  const AttachmentViewer({
    Key key,
    this.url,
  }) : super(key: key);
  @override
  _AttachmentViewerState createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends State<AttachmentViewer> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Center(
            child: _isLoading
                ? Center(child: spinLoader())
                : PDFViewer(
                    document: document,
                    zoomSteps: 1,
                    //uncomment below line to preload all pages
                    lazyLoad: false,
                    // uncomment below line to scroll vertically
                    // scrollDirection: Axis.vertical,

                    //uncomment below code to replace bottom navigation with your own
                    navigationBuilder:
                        (context, page, totalPages, jumpToPage, animateToPage) {
                      return Container(
                        height: 50.0,
                        color: kWhite,
                      );
                    },
                  ),
          ),
          Positioned(
              left: 8.0,
              top: 8.0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: kBlack,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    ));
  }
}
