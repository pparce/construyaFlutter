import 'package:flutter/material.dart';

class LibretaDirecciones extends StatefulWidget {
  LibretaDirecciones({Key key}) : super(key: key);

  @override
  _LibretaDireccionesState createState() => _LibretaDireccionesState();
}

class _LibretaDireccionesState extends State<LibretaDirecciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Libreta de Direcciones'),
      ),
    );
  }
}
