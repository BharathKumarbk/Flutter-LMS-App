import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/Authentication_wrap.dart';
import 'package:merit_coaching_app1/screens/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Tween<double> tween = Tween<double>(
    begin: 0,
    end: 1,
  );
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: Center(
        child: TweenAnimationBuilder(
            tween: tween,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image(
                  image: AssetImage("assets/images/meritFullLogo.png"),
                ),
              ),
            ),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            }),
      ),
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new AuthenticationWrapper()));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new OnBoardingPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: spinLoader(),
    );
  }
}
