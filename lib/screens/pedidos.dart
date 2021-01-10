import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  Pedidos({Key key}) : super(key: key);

  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Pedidos'),
      ),
    );
  }
}
