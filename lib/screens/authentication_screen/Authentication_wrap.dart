import 'package:merit_coaching_app1/components/bottom_navbar/bottomNav.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:merit_coaching_app1/screens/authentication_screen/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AppUser>(context);
    if (user != null) {

      return BottomNav();
    }
    return Authenticate();
  }
}
