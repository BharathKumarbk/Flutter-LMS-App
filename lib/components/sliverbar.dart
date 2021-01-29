

import 'package:flutter/material.dart';

import 'constants.dart';

class SliverScreen extends StatelessWidget {
  final String title;
  final bool allowPop;
  final Widget body;

  const SliverScreen({Key key, this.title, this.body, this.allowPop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
          child: Scaffold(
        backgroundColor: kWhite,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerScroll) {
              return [
                SliverAppBar(
                  
                    automaticallyImplyLeading: allowPop ? true : false,
                    backgroundColor: secondaryColor,
                    floating: true,
                    expandedHeight: 120.0,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // gradient: linearGradient,
                                  // color: Color(0xff534FF8),
                                  color:Color(0xff30475e),
                                ),
                              ),
                              Positioned(
                                  left: width - 100,
                                  top: -100.0,
                                  // bottom: 10.0,
                                  child: Container(
                                    // color: Color(0xff5D63FC),
                                    color:secondaryColor,
                                    height: 200.0,
                                    width: 200.0,
                                  )),
                              Positioned(
                                top: 50.0,

                                // bottom: 10.0,
                                child: Container(
                                  // color: Color(0xff3A37ED),
                                  color:secondaryColor,

                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.black26,
                              Colors.black12,
                              Colors.transparent,
                            ]),
                          ),
                        ),
                        Container(
                          child: SafeArea(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text(
                                      title ?? "",
                                      style: kGoogleMont.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kWhite,
                                          fontSize: 24.0),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ))),
              ];
            },
            body: body),
      ),
    );
  }
}
