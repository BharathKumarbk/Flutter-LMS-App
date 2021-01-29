import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';

class TermsAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backColor,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => Navigator.pop(context),
            )
          ],
          title: Text(
            "Terms and Condition",
            style: kGoogleNun,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoData(
                  "The terms \"our, us, and we\" used throughout the app refer to Merit Coaching. "),
              infoData(
                  "Carefully read our Terms of services before using or accessing our app. You must agree to our terms of services, by using or accessing any part of the service. You cannot access or use our service if you do not agree to all the terms and conditions of this agreement. If these terms of services are considered an offer, acceptance is expressly limited to these Terms of Services."),
              infoTitleSmall("Online term"),
              infoData(
                  "You can use our service by agreeing to our terms of services. If any violation of any of the services occurs, it will terminate immediately."),
              infoTitleSmall("Information accuracy"),
              infoData(
                  "We do our best to ensure that the information on the service is complete, accurate, and current. Some of the reasonable efforts on the app may occasionally be inaccurate, incomplete, or out of date. On the app, all specifications, services, descriptions, and prices of services subject to change at any time without notice. There is no warrant completeness or accuracy of the content, information, or materials & a guarantee that your computer will accurately display through the app. We have the right to discontinue any services at any time"),
              infoTitleSmall("Payment policy"),
              infoData(
                  "Our payment policy explains all of your rights & obligations when using Merit Coaching payments. It allows students to use various forms of payment on Merit Coaching, mobile apps, and other services. Students can pay with and accept payment by credit card, debit card & credits, or some bank transfer services like PayPal, Google Pay, Apple Pay, and a lot more."),
              infoData(
                  "You are agreeing to this policy and our terms of use by using Merit Coaching payments,"),
              infoData(
                  " 1. Accepting terms \n 2. Overview \n 3. Third-Party Services \n 4. Merit Coaching’s Rights and Responsibilities \n 5. Students Rights and Responsibilities \n 6. Appointment of limited payment collection agent for sellers \n 7. Deposits \n 8. Recoupment \n 9. Payment Processing Fees \n 10. Reporting Obligations \n 11. Termination"),
              infoTitleSmall("Intellectual property"),
              infoData(
                  "The app's materials include software, HTML code, script, text, images, graphics, video, audio are protected by copyrights.  The app content and features can only be used for personal and informational purposes by the students. Any kind of reproduction without their permission is strictly prohibited."),
              infoTitleSmall("Disclaimer liability"),
              infoData(
                  "It applies to any damages or injury caused by any failure of performance, error, interrupts, omission, deletion, delay of operation, or transmission. It includes the computer virus, communication line failure, destruction or theft or unauthorized access to, alteration of, or use of record, whether the breach of contract, tortious behavior, or under any other cause of action. The acknowledgment services of students are not liable for the defamatory, offensive, or legal-contact of other students or third parties and that the risk of injury from the rests entirely with the student."),
              infoTitleSmall("External Links"),
              infoData(
                  "Our app Merit Coaching may contain some of the links to third-party sites that are not under our control.  We do not imply endorsement by the inclusion of other apps or any association with operators of such apps.   Regarding the quality, nature, or reliability of other apps that are accessible by hyperlinks from the apps or link to the app, there are no claims and accepts no responsibilities.  Viewing and abiding by privacy statements and terms of use posted at any third-party app are visitors responsible."),
              infoTitleSmall("Terms of use"),
              infoData(
                  "Any content, any information provided by the user including user names, and passwords, addresses, email addresses, phone number, financial information( such as credit card numbers), information related to an employer name transmitted in connection with the apps are limited to the contemplated functionality of the apps."),
              infoData("Our app should not be used in a manner that"),
              infoData(
                  " •  any computer code, files, or programs that interrupt, destroy, introduce viruses or limit the functionality of computer software, hardware, or telecommunications equipment.\n •  user accounts and conduct that would constitute a criminal offense or that gives rise to civil liability. \n •  The terms Violation and damage, disable, overburden, or impair Merit Coaching servers or networks. \n •  Any person or entity impersonates or otherwise misrepresents your identity or affiliation with another person or entity comply with applicable third party terms."),
              infoData(
                  "Merit Coaching reserves the right, in its sole discretion, to terminate any User license, terminate any user participating, remove content, or assert legal action concerning the content or use of the app. Merit Coaching Reasonably believes or might violate these terms or Merit Coaching policies, including the Merit Coaching card terms and conditions. Delay in such actions does not constitute a waiver of its rights to enforce these terms."),
              infoTitleSmall("Conflict of terms "),
              infoData(
                  "Merit Coaching shall prevail in respect of your use of the relevant section or module of the service. If there is a contradiction or conflict between the provisions of our terms and conditions that relate specifically to a particular module or section of Merit Coaching, we will prevail."),
              infoTitleSmall("Applicable laws (choice of venue and forum)"),
              infoData(
                  "Regardless of the laws that might be applicable under principles of conflicts of law by the use of our Merit Coaching shall in all respects be governed by the laws of the state of Tamilnadu, India. "),
              infoTitleSmall("Severability "),
              infoData(
                  "Any provision of any relevant terms and conditions, policies and notices, which is or becomes unenforceable in any jurisdiction, whether due to being void, invalidity, illegality, unlawfulness or for any reason whatever, shall, in such jurisdiction only and only to the extent that it is so unenforceable, be treated as void and the remaining provisions of any relevant terms and conditions, policies and notices shall remain in full force and effect."),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
