import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/widgets/listado-productos.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class VistaImage extends StatelessWidget {
  const VistaImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VistaProductoArguments arguments =
        ModalRoute.of(context).settings.arguments;
    Product product = arguments.product;
    String image = Connections.IMAGE_BASE_URL + product.productImageMain;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Container(
        height: double.infinity,
        child: PhotoView(
          enableRotation: false,
          backgroundDecoration: BoxDecoration(color: Colors.white),
          imageProvider: NetworkImage(image),
          heroAttributes: PhotoViewHeroAttributes(tag: arguments.tag),
        ),
      ),
    );
  }
}
