import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/screens/favourite_screen/favourite.dart';
import 'package:merit_coaching_app1/screens/home_screen/home_page.dart';
import 'package:merit_coaching_app1/screens/profile_screen/profile_screen.dart';
import 'package:merit_coaching_app1/screens/purchased_screen/purchased_screen.dart';
import 'package:merit_coaching_app1/screens/search_screen/search_screen.dart';

import '../constants.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Widget bottomData;
  String connected = "";
  int index = 0;
  bool isConnect = true;
  List<Widget> tabBarWidgets = [
    HomePage(),
    SearchScreen(),
    FavouriteScreen(),
    PurchasedScreen(),
    ProfileScreen(),
  ];


// Be sure to cancel subscription after you are done

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (selectedIndex) {
              setState(() {
                index = selectedIndex;
              });
            },

            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            backgroundColor: kWhite,
            selectedItemColor: secondaryColor,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            unselectedItemColor: kBlack,
            selectedLabelStyle:
                kGoogleMont.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                kGoogleMont.copyWith(fontWeight: FontWeight.bold),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Home",
                activeIcon: Icon(EvaIcons.home),
                icon: Icon(EvaIcons.homeOutline),
              ),
              BottomNavigationBarItem(
                label: "Explore",
                activeIcon: Icon(EvaIcons.search),
                icon: Icon(
                  EvaIcons.searchOutline,
                ),
              ),
              BottomNavigationBarItem(
                label: "Favourites",
                activeIcon: Icon(EvaIcons.heart),
                icon: Icon(EvaIcons.heartOutline),
              ),
              BottomNavigationBarItem(
                label: "My Courses",
                activeIcon: Icon(EvaIcons.shoppingBag),
                icon: Icon(
                  EvaIcons.shoppingBagOutline,
                ),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                activeIcon: Icon(EvaIcons.person),
                icon: Icon(
                  EvaIcons.personOutline,
                ),
              ),
            ],
          ),
          body: FutureBuilder(
            future: checkConnection(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool hasConnection = snapshot.data;
                if (hasConnection) {
                  return tabBarWidgets[index];
                } else {
                  return noConnection();
                }
              } else {
                return Container(
                  color: kWhite,
                  child: Center(
                    child: spinLoader(),
                  ),
                );
              }
            },
          )),
    );
  }
}
