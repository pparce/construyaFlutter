import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function validator;
  final String label;
  final bool iconRequired;
  final bool enabled;
  const CustomTextField({
    Key key,
    this.controller,
    this.label,
    this.obscureText,
    this.validator,
    this.iconRequired = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          enabled: enabled,
          suffixIcon: iconRequired
              ? Icon(
                  Icons.ac_unit,
                  size: 5,
                  color: Colors.red,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          hintStyle: TextStyle(
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
            borderRadius: BorderRadius.circular(5),
            gapPadding: 5,
          ),
          labelText: label,
          focusColor: Theme.of(context).accentColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(5),
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
