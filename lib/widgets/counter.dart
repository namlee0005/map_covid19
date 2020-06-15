import 'package:covid19_map/constant.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final Color color;
  final String title;
  final int number;
  final int newNumber;
  const Counter({
    Key key,
    this.number,
    this.newNumber,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          format(number),
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: kSubTextStyle),
        SizedBox(height: 10),
        Text(
          "+" + format(newNumber),
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ),
      ],
    );
  }
}

String format(int number) {
  // Hien thi number theo chuan{
  String tmp = number.toString();
  if (tmp.length < 4) {
    return tmp;
  }
  String tmp2 = "";
  for (int i = 0; i < tmp.length - 1; i++) {
    if (((i + 1) % 3) == 0) {
      tmp2 = "," + tmp[(tmp.length - i - 1)] + tmp2;
    } else {
      tmp2 = tmp[(tmp.length - i - 1)] + tmp2;
    }
  }
  tmp2 = tmp[(0)] + tmp2;
  return tmp2;
}

