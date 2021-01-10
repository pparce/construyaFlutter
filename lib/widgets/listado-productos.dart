import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colour/colour.dart';
import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/favorito-serveice.dart';
import 'package:construyaalcosto/widgets/empty-screen.dart';
import 'package:construyaalcosto/widgets/qty.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';

class ListadoProductos extends StatelessWidget {
  static int HORIZONTAL = 0;
  static int VERTICAL = 1;
  final String title;
  final List<Product> products;
  final BuildContext context;
  final int orientacion;
  final bool isFavorite;
  final Function onRefrech;
  const ListadoProductos(
      {Key key,
      this.products,
      this.title,
      @required this.context,
      this.orientacion,
      this.isFavorite = false,
      this.onRefrech})
      : super(key: key);

  void _onTap(Product product) {
    Navigator.of(context).pushNamed('/vista-producto',
        arguments: VistaProductoArguments(
          product: product,
          tag: product.id.toString() + title,
        ));
  }

  void _onLongPress(Product product) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Opciones:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                isFavorite
                    ? ListTile(
                        leading: new Icon(Icons.favorite_border),
                        title: new Text('Quitar de Favoritos'),
                        onTap: () {
                          Navigator.pop(context);
                          _removeFromFavorite(product);
                        },
                      )
                    : ListTile(
                        leading: new Icon(Icons.favorite),
                        title: new Text('Agregar a favoritos'),
                        onTap: () {
                          Navigator.pop(context);
                          FavoritoService().addToFavorite(context, product);
                        },
                      ),
                ListTile(
                    leading: new Icon(Icons.share),
                    title: new Text('Compartir'),
                    onTap: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  void _onAddToCart(Product product) {
    _getProduct(product);
  }

  _getProduct(Product product) async {
    // CarroService().addToCart(product, 1);
    DialogsConnections.showLoadingDialog(context);
    String url = Connections.getUrlById(product.id, Connections.PRODUCTS_BY_ID);
    Response response = await Connections().get(url);
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      Product product = Product.fromJson(response.data);
      _showProductDialog(product);
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(context, () {
        _getProduct(product);
      }, () {});
    }
  }

  void _showProductDialog(Product product) {
    int qty = 1;
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(product.name),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextSubTitle(
                text: product.description,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    '\$' + product.productPricing.realPrice.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '\$' + product.productPricing.price.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(child: Qty(
                    onTextChange: (value) {
                      qty = value;
                    },
                  ))
                ],
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCELAR'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              CarroService().addToCart(product, qty);
              Scaffold.of(context).showSnackBar(
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
            },
            child: Text('AGREGAR AL CARRO'),
          ),
        ],
      ),
    );
  }

  void _addToFavorite(Product product) async {}

  void _removeFromFavorite(Product product) async {
    products.remove(product);
    FavoritoService().removeFromFavorite(context, product);
    if (onRefrech != null) {
      onRefrech();
      if (products.isEmpty) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _getHoriazontalList() {
    return Column(
      children: [
        title.length > 0
            ? Container(
                padding: EdgeInsets.only(top: 16),
                child: TextTitle(
                  margin: EdgeInsets.only(bottom: 16),
                  text: title,
                ),
              )
            : Container(),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return ProductCard(
                padding: index == 0 ? 8 : 0,
                title: title,
                product: product,
                onTap: () {
                  _onTap(product);
                },
                onLongPress: () {
                  _onLongPress(product);
                },
                onAddToCart: () {
                  _onAddToCart(product);
                },
              );
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _getVerticalList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.55,
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
      ),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return ProductCard(
          title: title,
          product: product,
          onTap: () {
            _onTap(product);
          },
          onLongPress: () {
            _onLongPress(product);
          },
          onAddToCart: () {
            _onAddToCart(product);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return products.length > 0
        ? Container(
            height: orientacion == 1 ? double.infinity : 400,
            // padding: EdgeInsets.only(top: 16),
            child:
                orientacion == 1 ? _getVerticalList() : _getHoriazontalList(),
          )
        : orientacion == 1
            ? EmptyScreen(
                icon: Icons.local_mall,
                label: 'No se encontraron Productos',
              )
            : Container(
                height: 250,
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => ProductCardShimmer(),
                ),
              );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function onTap;
  final Function onLongPress;
  final Function onAddToCart;
  final String title;
  final double padding;
  const ProductCard(
      {Key key,
      this.product,
      this.onTap,
      this.onLongPress,
      this.onAddToCart,
      this.title,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: padding ?? 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            width: 180,
            height: double.infinity,
            child: Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: product.id.toString() + title,
                          child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                              imageUrl: Connections.IMAGE_BASE_URL +
                                  product.productImageThumbnail),

                          /* Image.network(
                            Connections.IMAGE_BASE_URL +
                                product.productImageThumbnail,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  : Shimmer.fromColors(
                                      child: Container(
                                        color: Colors.grey[300],
                                        height: 180,
                                        width: double.infinity,
                                      ),
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.white,
                                    );
                            },
                          ), */
                        ),
                      ),
                      Divider(
                        thickness: 0.1,
                        color: Colors.black,
                        indent: 0,
                        height: 0.5,
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            text: product.name,
                          ),
                        ),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            text: product.description,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$' +
                                  product.productPricing.realPrice.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '\$' + product.productPricing.price.toString(),
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 8),
                    width: double.infinity,
                    child: OutlineButton(
                      highlightedBorderColor:
                          Theme.of(context).accentColor.withOpacity(0.3),
                      highlightColor:
                          Theme.of(context).accentColor.withOpacity(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'AGREGAR',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                      onPressed: onAddToCart,
                      onLongPress: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          width: 200,
          height: 200,
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: Duration(milliseconds: 2000),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.grey[300],
                          height: 150,
                          width: 200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Flexible(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: Duration(milliseconds: 2000),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.grey[300],
                          width: double.infinity,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: Duration(milliseconds: 2000),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.grey[300],
                          width: double.infinity,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: Duration(milliseconds: 2000),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.grey[300],
                          width: 100,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VistaProductoArguments {
  final String tag;
  final Product product;

  VistaProductoArguments({this.product, this.tag});
}
