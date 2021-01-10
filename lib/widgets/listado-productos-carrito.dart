import 'package:cached_network_image/cached_network_image.dart';
import 'package:construyaalcosto/models/cart.dart';
import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/widgets/tabla-totales.dart';
import 'package:construyaalcosto/widgets/text-disabled.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListadoProductosCarrito extends StatelessWidget {
  final Cart cart;
  final Function onLongPress;
  const ListadoProductosCarrito({Key key, this.onLongPress, this.cart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> items = cart.items;
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return index == items.length - 1
              ? Column(
                  children: [
                    _ItemListadoCarrito(
                      item: items[index],
                      onLongPress: onLongPress,
                    ),
                    TablaTotales(
                      cart: cart,
                    ),
                  ],
                )
              : _ItemListadoCarrito(
                  item: items[index],
                  onLongPress: onLongPress,
                );
        },
      ),
    );
  }
}

class _ItemListadoCarrito extends StatelessWidget {
  final Item item;
  final Function onLongPress;
  const _ItemListadoCarrito({Key key, this.item, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = item.product;
    return InkWell(
      onTap: () {},
      onLongPress: () {
        onLongPress(item);
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.3))),
        padding: EdgeInsets.only(left: 8, right: 16, bottom: 16, top: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                width: 80,
                height: 80,
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
                imageUrl:
                    Connections.IMAGE_BASE_URL + product.productImageThumbnail,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle(
                    margin: EdgeInsets.only(bottom: 8),
                    text: product.name,
                  ),
                  Text(
                    '\$' + item.price.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('Cantidad'),
                            SizedBox(
                              height: 4,
                            ),
                            Text(item.qty.toString()),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Impuesto(\$)',
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(0.toString()),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total(\$)'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(item.subTotal.toStringAsFixed(2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
