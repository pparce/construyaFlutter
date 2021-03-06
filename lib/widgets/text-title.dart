import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry margin;
  final double fontSize;
  const TextTitle({Key key, this.text, this.margin, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
