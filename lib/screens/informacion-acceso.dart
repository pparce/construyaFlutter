import 'package:flutter/material.dart';

class InformacionAcceso extends StatefulWidget {
  InformacionAcceso({Key key}) : super(key: key);

  @override
  _InformacionAccesoState createState() => _InformacionAccesoState();
}

class _InformacionAccesoState extends State<InformacionAcceso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de Acceso'),
      ),
    );
  }
}
