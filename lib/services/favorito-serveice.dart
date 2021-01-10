import 'package:construyaalcosto/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritoService {
  static FavoritoService _instance;
  Box box;
  List<String> favoritos = [];

  FavoritoService._internal() {
    _instance = this;
  }

  bool isFavorito(Product product) {
    return favoritos.contains(productToJson(product));
  }

  void addToFavorite(BuildContext context, Product product) async {
    box = await Hive.openBox('app');
    favoritos = box.get('favoritos', defaultValue: <String>[]);
    if (favoritos.contains(productToJson(product))) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red[800],
          content: Text('Este producto ya esta en Favoritos'),
        ),
      );
    } else {
      favoritos.add(productToJson(product));
      box.put('favoritos', favoritos);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[800],
          duration: Duration(milliseconds: 2000),
          content: Text('Producto agregado a Favoritos'),
        ),
      );
    }
  }

  void removeFromFavorite(BuildContext context, Product product) async {
    box = await Hive.openBox('app');
    favoritos = box.get('favoritos', defaultValue: <String>[]);
    favoritos.remove(productToJson(product));
    box.put('favoritos', favoritos);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[800],
        duration: Duration(milliseconds: 2000),
        content: Text('Producto quitado de Favoritos'),
      ),
    );
  }

  void clearFavorite() async {
    box = await Hive.openBox('app');
    box.put('favoritos', <String>[]);
  }

  factory FavoritoService() => _instance ?? FavoritoService._internal();
}
