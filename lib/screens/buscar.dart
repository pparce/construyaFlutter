import 'package:construyaalcosto/widgets/search_field.dart';
import 'package:flutter/material.dart';

class Buscar extends StatefulWidget {
  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchField(onTextChange: (String value) {
          // initState();
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
