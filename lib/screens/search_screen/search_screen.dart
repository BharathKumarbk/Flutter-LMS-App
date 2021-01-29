import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/course_list_item.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/models/course.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Future resultsLoaded;
  List<SingleCourseModel> allResults = [];
  List<SingleCourseModel> resultsList = [];
  bool isShowResult;
  String filterString;
  @override
  void initState() {
    isShowResult = false;
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getListofCourse();
  }

  _onSearchChanged() {
    searchResultsList();
  }



  priceSearch(String price) {
    List<SingleCourseModel> showResults = [];

    if (price != "") {
      if (price == "free") {
        for (var coursenapshot in allResults) {
          var title = coursenapshot.coursePrice.toLowerCase();

          if (title.contains(price.toLowerCase())) {
            showResults.add(coursenapshot);
          }
        }
      } else if (price == "Below 300") {
        for (var coursenapshot in allResults) {
          if (!(coursenapshot.coursePrice == "free")) {
            var title = coursenapshot.coursePrice.toLowerCase();

            if (int.parse(title) <= 300) {
              showResults.add(coursenapshot);
            }
          }
        }
      } else if (price == "Below 500") {
        for (var coursenapshot in allResults) {
          if (!(coursenapshot.coursePrice == "free")) {
            var title = coursenapshot.coursePrice.toLowerCase();

            if (int.parse(title) <= 500) {
              showResults.add(coursenapshot);
            }
          }
        }
      } else if (price == "Below 1000") {
        for (var coursenapshot in allResults) {
          if (!(coursenapshot.coursePrice == "free")) {
            var title = coursenapshot.coursePrice.toLowerCase();

            if (int.parse(title) <= 1000) {
              showResults.add(coursenapshot);
            }
          }
        }
      } else if (price == "Above 1000") {
        for (var coursenapshot in allResults) {
          if (!(coursenapshot.coursePrice == "free")) {
            var title = coursenapshot.coursePrice.toLowerCase();

            if (int.parse(title) > 1000) {
              showResults.add(coursenapshot);
            }
          }
        }
      } else {
        showResults = List.from(allResults);
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  subjectSearch(String subject) {
    List<SingleCourseModel> showResults = [];

    if (subject != "") {
      for (var coursenapshot in allResults) {
        var title = coursenapshot.courseSubject.toLowerCase();

        if (title.contains(subject.toLowerCase())) {
          showResults.add(coursenapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  classSearch(int userClass) {
    List<SingleCourseModel> showResults = [];

    if (userClass != null) {
      for (var coursenapshot in allResults) {
        var title = int.parse(coursenapshot.courseClass);

        if (title == userClass) {
          print(coursenapshot.courseClass);
          showResults.add(coursenapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  searchResultsList() {
    List<SingleCourseModel> showResults = [];

    if (searchController.text != "") {
      for (var coursenapshot in allResults) {
        var title = coursenapshot.courseName.toLowerCase();

        if (title.contains(searchController.text.toLowerCase())) {
          showResults.add(coursenapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  getListofCourse() async {
    var data = await FirebaseFirestore.instance
        .collection("School")
        .doc("Courses Id")
        .collection("Courses")
        .get();

    setState(() {
      allResults = data.docs.map((e) => SingleCourseModel.fromMap(e)).toList();
    });
    searchResultsList();

    return "complete";
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);

    searchController.dispose();
    super.dispose();
  }

  Widget showResults(String result) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Filtered results for : ",
                style: kGoogleNun,
              ),
              Text(
                "$result",
                style: kGoogleNun.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  resultsLoaded = getListofCourse();
                  setState(() {
                    isShowResult = false;
                  });
                },
                child: Text(
                  "Clear filter",
                  style: kGoogleNun.copyWith(
                    color: tealColor,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  final List<String> price = [
    "free",
    "Below 300",
    "Below 500",
    "Below 1000",
    "Above 1000"
  ];

  final List<String> subjects = [
    "maths",
    "English",
    "Tamil",
    "Botany",
    "Zoology",
    "Physics",
    "Chemistry",
    "Computer science",
    "History",
    "Geography",
    "Civics",
    "Hindi",
  ];

  final List<String> userClasses = [
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII"
  ];

  int userClass(String classUser) {
    if (classUser == "I")
      return 1;
    else if (classUser == "II")
      return 2;
    else if (classUser == "III")
      return 3;
    else if (classUser == "IV")
      return 4;
    else if (classUser == "V")
      return 5;
    else if (classUser == "VI")
      return 6;
    else if (classUser == "VII")
      return 7;
    else if (classUser == "VIII")
      return 8;
    else if (classUser == "IX")
      return 9;
    else if (classUser == "X")
      return 10;
    else if (classUser == "XI")
      return 11;
    else
      return 12;
  }

  bool filterShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: appBar(),
        body: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kWhite,
              elevation: 0.0,
              flexibleSpace: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                                hintText: "Search courses",
                                contentPadding: const EdgeInsets.all(8.0),
                                filled: true,
                                suffixIcon: Icon(EvaIcons.search),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12))),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: kBlack,
                            ),
                            onPressed: () {
                              showBottomSheet(
                                backgroundColor: backColor,
                                context: context,
                                builder: (context) => Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppBar(
                                        automaticallyImplyLeading: false,
                                        actions: [
                                          IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () =>
                                                  Navigator.pop(context))
                                        ],
                                        backgroundColor: backColor,
                                        title: Text("Choose your filter",
                                            style: kGoogleNun.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        centerTitle: true,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: titleTextWhite(
                                                  "Filter by Class"),
                                            ),
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              children: userClasses
                                                  .map((e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: FlatButton(
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onPressed: () {
                                                              classSearch(
                                                                  userClass(e));
                                                              setState(() {
                                                                filterString =
                                                                    "Class $e";

                                                                isShowResult =
                                                                    true;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            color: kWhite,
                                                            child: Text(
                                                              "Class $e",
                                                              style: kGoogleNun
                                                                  .copyWith(
                                                                      color:
                                                                          tealColor),
                                                            )),
                                                      ))
                                                  .toList(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: titleTextWhite(
                                                  "Filter by Subject"),
                                            ),
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              children: subjects
                                                  .map((e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: FlatButton(
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onPressed: () {
                                                              subjectSearch(e);
                                                              setState(() {
                                                                filterString =
                                                                    e;

                                                                isShowResult =
                                                                    true;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            color: kWhite,
                                                            child: Text(
                                                              e,
                                                              style: kGoogleNun
                                                                  .copyWith(
                                                                      color:
                                                                          tealColor),
                                                            )),
                                                      ))
                                                  .toList(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: titleTextWhite(
                                                  "Filter by Price"),
                                            ),
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              children: price
                                                  .map((e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: FlatButton(
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onPressed: () {
                                                              priceSearch(e);
                                                              setState(() {
                                                                filterString =
                                                                    e;

                                                                isShowResult =
                                                                    true;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            color: kWhite,
                                                            child: Text(
                                                              e,
                                                              style: kGoogleNun
                                                                  .copyWith(
                                                                      color:
                                                                          tealColor),
                                                            )),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    )),
              ),
            ),
            isShowResult ? showResults(filterString) : Container(),
            Expanded(
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: resultsList.length == 0
                      ? Center(child: emptyWidget("No results Found", context))
                      : ListView.builder(
                          itemCount: resultsList.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListCourseTile(
                                courseModel: resultsList[index],
                              ),
                            );
                          },
                        )),
            ),
          ],
        ));
  }
}
