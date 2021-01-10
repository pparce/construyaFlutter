import 'package:cached_network_image/cached_network_image.dart';
import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/services/favorito-serveice.dart';
import 'package:construyaalcosto/widgets/listado-productos.dart';
import 'package:construyaalcosto/widgets/qty.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:shimmer/shimmer.dart';

class VistaProducto extends StatefulWidget {
  VistaProducto({Key key}) : super(key: key);

  @override
  _VistaProductoState createState() => _VistaProductoState();
}

class _VistaProductoState extends State<VistaProducto> {
  Product product;
  List<Product> productsRelated = [];
  int qty = 1;
  CarroService carroService;
  final _scaffKey = GlobalKey<ScaffoldState>();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    carroService = CarroService();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getProductById();
      _getRelatedProducts();
    });
  }

  _getProductById() async {
    // DialogsConnections.showLoadingDialog(context, _keyLoader);
    final Response response = await Connections()
        .get(Connections.getUrlById(product.id, Connections.PRODUCTS_BY_ID));

    // DialogsConnections.hideLoadingDialog(_keyLoader);
    if (response != null && response.statusCode == 200) {
      setState(() {
        product = Product.fromJson(response.data);
      });
    } else {}
  }

  _getRelatedProducts() async {
    // DialogsConnections.showLoadingDialog(context, _keyLoader);
    final Response response = await Connections()
        .get(Connections.getUrlById(product.id, Connections.PRODUCTS_RELATED));

    // DialogsConnections.hideLoadingDialog(_keyLoader);
    if (response != null && response.statusCode == 200) {
      setState(() {
        productsRelated =
            List<Product>.from(response.data.map((x) => Product.fromJson(x)));
      });
    } else {}
  }

  void _showProductAddSnackBar() {
    _scaffKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[800],
        duration: Duration(milliseconds: 2000),
        content: Text('Producto agregado al carrito'),
        action: SnackBarAction(
          label: 'ver',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pushNamed('/carro');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    VistaProductoArguments arguments =
        ModalRoute.of(context).settings.arguments;
    product = arguments.product;
    isFavorite = FavoritoService().isFavorito(product);
    String image = Connections.IMAGE_BASE_URL + product.productImageThumbnail;
    return Scaffold(
      key: _scaffKey,
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                if (isFavorite) {
                  FavoritoService().removeFromFavorite(context, product);
                } else {
                  FavoritoService().addToFavorite(context, product);
                }
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {});
                });
              },
            ),
          )
        ],
      ),
      body: Container(
        child: ListView(
          // physics: BouncingScrollPhysics(),
          children: [
            Hero(
              tag: arguments.tag,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/vista-image',
                        arguments: VistaProductoArguments(
                          product: product,
                          tag: arguments.tag,
                        ));
                  },
                  child: CachedNetworkImage(
                      height: 300,
                      imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          child: Container(
                            color: Colors.grey[300],
                            height: 300,
                            width: double.infinity,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.white,
                        );
                      },
                      imageUrl: image)),
            ),
            Divider(
              color: Colors.black12,
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle(
                    text: product.name,
                  ),
                  TextSubTitle(
                    text: product.description,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        product.productPricing.realPrice.toString(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        product.productPricing.price.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Qty(
                          onTextChange: (value) {
                            qty = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textColor: Colors.white,
                    highlightColor: Theme.of(context).accentColor,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      carroService.addToCart(product, qty);
                      _showProductAddSnackBar();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'AGREGAR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) => ListadoProductos(
                context: context,
                title: 'Productos Relacionados',
                products: productsRelated,
                orientacion: ListadoProductos.HORIZONTAL,
              ),
            )
          ],
        ),
      ),
    );
  }
}
