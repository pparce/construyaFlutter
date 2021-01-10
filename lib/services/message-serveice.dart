import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MessageService {
  static MessageService _instance;
  Box box;
  List<String> favoritos = [];

  MessageService._internal() {
    _instance = this;
  }

  static showMessage(
      {BuildContext context,
      String mensaje,
      bool isNegative = false,
      int duration = 2000}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isNegative ? Colors.red[800] : Colors.green[800],
        duration: Duration(milliseconds: duration),
        content: Text(mensaje),
      ),
    );
  }

  factory MessageService() => _instance ?? MessageService._internal();
}
