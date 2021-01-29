import 'package:flutter/material.dart';
import 'package:merit_coaching_app1/components/constants.dart';
import 'package:merit_coaching_app1/components/reuse.dart';

class PrivacyPolicy extends StatelessWidget {
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
            "Privacy Policy",
            style: kGoogleNun,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoTitlelarge("School App-Privacy Policy"),
              infoData(
                  "Merit Coaching operates the app and hereinafter \"us\", \"we\", or \"our\" referred to School Coaching app."),
              infoData(
                  "This page informs you that of our policies regarding disclosure, collection, use of personal data when you use our Service. And also regarding the choices you have associated with that data."),
              infoData(
                  "We collect the data from you to improve the service. You must agree to the collection and use of information when you are using our services under this policy. The terms used in our Privacy Policy have the same meanings in our Terms and Conditions."),
              infoTitleSmall("Information Collection and Use"),
              infoData(
                  "We collect the information from you for different purposes such as to improve our service to you."),
              infoTitlelarge("Types of data collected "),
              infoTitleSmall("Personal data"),
              infoData(
                  "We may ask you while using our Service to provide us with certain personally identifiable information that can be used to contact you. The Identifiable information may include Cookies and Usage Data."),
              infoTitleSmall("Usage Data"),
              infoData(
                  "The information your browser sends whenever you visit or access our services by mobile devices is usage data. The usage data includes information such as your device’s IP address, pages of our services you visit, browser version, the date and time of your visit, time spent on our app, and other diagnostic data. "),
              infoData(
                  "And other information we collect such as your mobile device type, Unique ID, IP address, device identifier, type of operating system, and browser you use, and other diagnostic data."),
              infoTitlelarge("Tracking & Cookies Data"),
              infoData(
                  "We collect Cookies (files with a small amount of data that include an anonymous unique identifier) & hold certain information and use tracking technologies to track the activity on our service. Some tracking technologies tags, beacons, and scripts are used to collect and track information."),
              infoData(
                  "You may instruct your browser to refuse all of the cookies, but you may not be able to use some portion of our services if you don’t accept cookies."),
              infoData("We use some of the cookies such as"),
              infoData(
                  " •  Session Cookies to operate our services.\n •  Preference Cookies to remember your various settings (Preferences).\n •  Security Cookies for security purposes."),
              infoTitleSmall("Technologies used to collect the information:"),
              infoData(
                  " • Cookies act as an anonymous identifier.\n • Log files collect the data such as IP address, internet service provider, date/time stamps.\n • Electronic files, such as beacons, tags, pixels, are used to record information.When you attempt your purchase on our app, we collect your personal order information like name, billing address, shipping address, payment information( credit card numbers, debit card, digital payment), email address, phone number, and a lot more."),
              infoTitleSmall("How do we use your personal information?"),
              infoData(
                  "We collect your personal information,\n • To optimize and improve our app (by generating analytics)\n • For advertising campaigns\n • Communication with you\n • To provide you advertising relating to our product or services.\n • To screen our order for potential risk or fraud( in particular, your IP address).\n • Applicable email marketing- with your permission, we may send you an email about our store or new services and other updates."),
              infoTitleSmall("Disclosure of Data"),
              infoTitlelarge("Legal Requirement"),
              infoData(
                  "Merit Coaching may disclose your Personal Data in good belief. The required actions"),
              infoData(
                  " •  Comply with a legal obligation\n •  Defend & Protect the rights or property of Merit Coaching.\n •  Investigate & Prevent possible wrongdoing in connection with our services.\n •  Prevent the personal safety of users\n •  Protect against legal liability."),
              infoTitlelarge("Security of Data"),
              infoData(
                  "The security of your personal data & information is important to us. There is no method of transmission over the internet or electronic storage is 100% secure. We almost strive to use commercially acceptable to protect your personal information but do not guarantee absolute semeans curity."),
              infoTitlelarge("Service Providers"),
              infoData(
                  "We facilitate our service to assist us in analyzing how our service is used by employing third party companies and individuals. These parties have access to your personal data that are obligated not to disclose or use it for any other purpose."),
              infoTitlelarge("Analytics"),
              infoData(
                  "For analyzing and monitoring the use of our services, we use third-party service providers."),
              infoData("   •  Google Analytics"),
              infoData(
                  "Google offers an analytics service that tracks and reports app traffic. Google uses the data collected to monitor and track our service & to contextualize and personalize the ads of its advertising network. Visit the link https://policies.google.com/privacy?hl=en, if you want more information on the privacy policies of Google."),
              infoTitleSmall("Changes to This Privacy Policy"),
              infoData(
                  "Our Privacy Policy or Practice may change from time to time. Before the change becomes effective, Let you know via email or/and a prominent notice on our service & update the effective date at the top of this privacy policy when they post on this page.  "),
              infoTitleSmall("Sharing your personal information:"),
              infoData(
                  "We share & use the information as described above. It is not limited to your consent for sharing your information as per this privacy policy. But you disclose the use of the data collected."),
              infoTitleSmall("User consent"),
              infoTitlelarge("Behavioural Advertising"),
              infoData(
                  "The information provided by you is used only for targeted advertising and marketing communication."),
              infoTitlelarge("Do not track"),
              infoData(
                  "Enable the 'Do not track’ signal to your browser. When we see that signal, we won’t use the practices."),
              infoTitlelarge("Your rights"),
              infoData(
                  "You can have the right to ask that your personal information be corrected, updated, or deleted. If you want any release, contact us through the mail. You can opt-out of targeted advertising from Facebook, Google, Bing, Email. The unsubscribe button is available to opt-out of our advertising message."),
              infoTitlelarge("Security"),
              infoData(
                  "We use reasonable precautions & follow all PCI-DSS requirements to ensure 100% security to your personal information."),
              infoTitlelarge("Payment"),
              infoData(
                  "Your transaction data is stored only if necessary, and encryption through PCI-DSS."),
              infoTitlelarge("Data Retention"),
              infoData(
                  "For our records, we maintain all of your system and order information until you ask to release them."),
              infoTitlelarge("Changes"),
              infoData(
                  "For our operational, legal, or regulatory reasons, we may update or change this privacy policy from time to time."),
              infoTitlelarge("Third-party site"),
              infoData(
                  "We don’t take the responsibilities when you click on the links of the third-party site. Make it clear with their privacy policy and then go to that app. We don’t have control over and assume no responsibility for the content, privacy practices, or policies of any third-party site."),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
