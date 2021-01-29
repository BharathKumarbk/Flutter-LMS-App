import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:merit_coaching_app1/components/vertical_course_grid/listCousreGrid.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';

class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var courseUser = Provider.of<AuthenticationService>(context);
    var courseProvider = Provider.of<FirebaseCourseRepo>(context);

    return Scaffold(
        backgroundColor: kWhite,
        appBar: appBar(),
        body: courseUser.userCred.uid == null
            ? Container(
                height: double.infinity,
                child:
                    Center(child: emptyWidget("Your Cart is Empty", context)),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListCourseGrid(
                      screen: 'Your Cart',
                      courseStream: courseProvider.getListofCourseByFavourites(
                        courseUser.userCred.uid,
                      )),
                ),
              ));
  }
}
