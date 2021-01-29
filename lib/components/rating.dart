import 'package:flutter/material.dart';

import 'constants.dart';

class RatingStar extends StatelessWidget {
  final String value;
  final double size;
  const RatingStar({Key key, this.size, this.value})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.star,
          color: Colors.orange[700],
          size: size,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text(
          value,
          style: kGoogleMont.copyWith(color: kBlack),
        )
      ]),
    );
  }
}
