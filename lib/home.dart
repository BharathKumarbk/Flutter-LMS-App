
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/screens/intro.dart';
import 'package:merit_coaching_app1/services/firebase_auth.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:merit_coaching_app1/services/firebase_course_repo.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser>.value(
          value: AuthenticationService().user,
          catchError: (c, o) {
            return;
          },
        ),
        ChangeNotifierProvider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider<StorageRepo>(
          create: (_) => StorageRepo(),
        ),
        ChangeNotifierProvider<FirebaseUserService>(
          create: (_) => FirebaseUserService(),
        ),
        ChangeNotifierProvider<FirebaseCourseRepo>(
          create: (_) => FirebaseCourseRepo(),
        ),
        ChangeNotifierProvider<FirebaseCourseLogic>(
          create: (_) => FirebaseCourseLogic(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: secondaryColor,
          backgroundColor: kWhite,
          appBarTheme: AppBarTheme(color: kWhite, elevation: 0.0),
        ),
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
        // home: OnBoardingPage(),
      ),
    );
  }
}

// class Router {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => Wrapper());
//       case '/home':
//         return MaterialPageRoute(builder: (_) => BottomNav());
//       case '/moreScreen':
//         return MaterialPageRoute(builder: (_) => ListCourseMore());
//       default:
//         return MaterialPageRoute(
//             builder: (_) => Scaffold(
//                   body: Center(
//                       child: Text('No route defined for ${settings.name}')),
//                 ));
//     }
//   }
// }
