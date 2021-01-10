import 'dart:developer';

import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/favorito-serveice.dart';
import 'package:construyaalcosto/widgets/empty-screen.dart';
import 'package:construyaalcosto/widgets/listado-productos.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Favoritos extends StatefulWidget {
  Favoritos({Key key}) : super(key: key);

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _getProductosFavoritos();
  }

  _getProductosFavoritos() async {
    Box box = await Hive.openBox('app');
    List<String> favoritos = box.get('favoritos', defaultValue: <String>[]);
    setState(() {
      products = favoritos.map((e) => productFromJson(e)).toList();
    });
  }

  _clearFavoritos() async {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Eliminar Favoritos'),
          content:
              Text('¿Estas seguro de querer eliminar el listado de Favoritos?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCELAR'),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  products = [];
                });
                FavoritoService().clearFavorite();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('ELIMINAR'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        actions: [
          Visibility(
            visible: products.isNotEmpty,
            child: IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                _clearFavoritos();
              },
            ),
          )
        ],
      ),
      body: Container(
        child: products.length > 0
            ? Builder(
                builder: (BuildContext context) => ListadoProductos(
                  context: context,
                  products: products,
                  title: '',
                  orientacion: ListadoProductos.VERTICAL,
                  isFavorite: true,
                  onRefrech: () {
                    setState(() {});
                  },
                ),
              )
            : EmptyScreen(
                icon: Icons.favorite_border,
                label: 'No hay productos Favoritos',
              ),
      ),
    );
  }
}
