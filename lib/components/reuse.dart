import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

Widget titleText(String title) {
  return Text(
    "$title",
    style: kGoogleMont.copyWith(
        color: kBlack, fontWeight: FontWeight.bold, fontSize: 16.0),
  );
}

Widget titleTextWhite(String title) {
  return Text(
    "$title",
    style: kGoogleMont.copyWith(
        color: kWhite, fontWeight: FontWeight.bold, fontSize: 16.0),
  );
}

Widget emptyWidget(String data, context) {
  return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 50.0, child: Image.asset("assets/images/emptyBox.png")),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$data",
              style: kGoogleNun.copyWith(
                  fontSize: 14.0, fontWeight: FontWeight.bold, color: kBlack),
            ),
          )
        ],
      ));
}

AppBar appBar() {
  return AppBar(
    backgroundColor: backColor,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        ClipOval(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: kWhite,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset("assets/images/meritLogo.png"),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          "Merit Coaching",
          style:
              kGoogleNun.copyWith(color: kWhite, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

error(String error, context) {
  showDialog(
      context: context,
      child: AlertDialog(
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"))
        ],
        title: Container(
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.warning,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(error,
                        style: kGoogleNun.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )),
      ));
}

Widget progressBar() {
  return LinearProgressIndicator(
    backgroundColor: kWhite,
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

String dateFormat(String date) {
  return DateFormat("hh:mm a dd/M/yyyy").format(DateTime.parse(date));
}

String pickCorrectAnswer(String value, List<String> options) {
  int num = int.parse(value);
  return options[num - 1];
}

String priceText(
  String price,
) {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: "en_in");

  return price == "free"
      ? "free"
      : "${formatCurrency.format(int.parse(price))}";
}

Widget accountText(
  String top,
  String bottom,
  Color colorTop,
  Color colorbottom,
  // double topSize,
  // double bottomSize,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          "$top",
          style: kGoogleNun.copyWith(
              fontWeight: FontWeight.bold,
              // fontSize: topSize,
              color: colorTop,
              fontSize: 30.0),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          "$bottom",
          style: kGoogleNun.copyWith(
            // fontSize: bottomSize,
            color: colorbottom,
          ),
        ),
      ),
    ],
  );
}

Widget percentCard(String length, String title) {
  return Expanded(
      child: Row(
    children: [
      Text(
        "$length",
        style: kGoogleNun.copyWith(color: secondaryColor),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          "$title",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: kGoogleNun.copyWith(
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
      ),
      Text(
        "$length",
        style: kGoogleNun.copyWith(color: secondaryColor),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          "$title",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: kGoogleNun.copyWith(
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
      )
    ],
  ));
}

bool emailValidate(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(email);
}

Widget settingsWrap(String title, IconData icon, Function function) {
  return Container(
      margin: const EdgeInsets.all(4.0),
      color: Colors.grey[50],
      child: Material(
        child: InkWell(
          onTap: function,
          child: Container(
              height: 100.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      child: Icon(
                        icon,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "$title",
                      style: kGoogleNun.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              )),
        ),
        color: Colors.transparent,
      ));
}

Widget spinLoader() {
  return Center(
      child: SpinKitChasingDots(
    color: secondaryColor,
  ));
}

Widget infoTitlelarge(
  String title,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: kGoogleNun.copyWith(
          color: kBlack, fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
  );
}

Widget infoTitleSmall(
  String title,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: kGoogleNun.copyWith(
          color: tealColor, fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
  );
}

Widget infoData(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: kGoogleNun.copyWith(color: kBlack, fontSize: 16.0),
    ),
  );
}

Widget noConnection() {
  return Container(
    color: kWhite,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 300.0,
            child: Image(image: AssetImage("assets/images/Nointernet.png"))),
        Text(
          "Oops!",
          style: kGoogleNun.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ],
    ),
  );
}

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}
