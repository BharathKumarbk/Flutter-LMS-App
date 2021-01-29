import 'package:google_fonts/google_fonts.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/Authentication_wrap.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AuthenticationWrapper()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Merit Coaching for a Better Interaction",
          body:
              "Students can improve their writing skills, ability to speak, and enhance their knowledge. Once you have it, you love it.",
          image: _buildImage('1'),
          decoration: PageDecoration(
            titleTextStyle: GoogleFonts.nunito(
                fontSize: 28.0, fontWeight: FontWeight.w700, color: kWhite),
            bodyTextStyle: kGoogleNun.copyWith(fontSize: 19.0, color: kWhite),
            descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            pageColor: Colors.blue,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "Enhance the student’s learning experiences",
          body:
              "Connect with the school community and Enrich student classroom experience.",
          image: _buildImage('2'),
          decoration: PageDecoration(
            titleTextStyle: GoogleFonts.nunito(
                fontSize: 28.0, fontWeight: FontWeight.w700, color: kWhite),
            bodyTextStyle: kGoogleNun.copyWith(fontSize: 19.0, color: kWhite),
            descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            pageColor: secondaryColor,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "Make Student Master Each of their Subjects",
          bodyWidget: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 100.0),
            height: 50.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              color: kWhite,
              onPressed: () => _onIntroEnd(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Started",
                    style:
                        kGoogleNun.copyWith(color: backColor, fontSize: 18.0),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                  )
                ],
              ),
            ),
          ),
          image: _buildImage('3'),
          decoration: PageDecoration(
            titleTextStyle: GoogleFonts.nunito(
                fontSize: 28.0, fontWeight: FontWeight.w700, color: kWhite),
            bodyTextStyle: kGoogleNun.copyWith(fontSize: 19.0, color: kWhite),
            descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            pageColor: backColor,
            imagePadding: EdgeInsets.zero,
          ),
        ),
      ],
      onDone: () => null,
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(color: kWhite),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: kWhite,
      ),
      done: Container(),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: kWhite,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
