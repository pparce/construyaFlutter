import 'package:flutter/material.dart';

class TextDisabled extends StatelessWidget {
  final String text;
  const TextDisabled({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey[500]),
      ),
    );
  }
}
