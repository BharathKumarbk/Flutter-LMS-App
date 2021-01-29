import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          infoTitlelarge("Contact"),
          Divider(),
          infoData(
              "Please Kindly report if you find any mistakes in our content & it helps us to correct our mistakes. It also helps other users from incorrect content."),
          infoData(
              "If you have any suggestions to make Merit Coaching Better, You can call or WhatsApp on the below number. Or you can write an email."),
          Divider(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.call,
                  color: tealColor,
                  size: 14.0,
                ),
              ),
              Text(
                "1234567890",
                style: kGoogleNun.copyWith(color: tealColor),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.mail,
                  color: tealColor,
                  size: 14.0,
                ),
              ),
              Text(
                "meritcoaching@gmail.com",
                style: kGoogleNun.copyWith(color: tealColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
