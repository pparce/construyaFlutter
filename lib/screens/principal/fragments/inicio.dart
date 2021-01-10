import 'dart:developer';
import 'dart:io';

import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/screens/productos.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/widgets/image-swiper.dart';
import 'package:construyaalcosto/widgets/listado-productos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class InicioFragment extends StatefulWidget {
  InicioFragment({Key key}) : super(key: key);

  @override
  _InicioFragmentState createState() => _InicioFragmentState();
}

class _InicioFragmentState extends State<InicioFragment> {
  List<String> banners = [
    'http://construyaalcosto.storebow.scoutframe.com/assets/store/templates/construyaalcosto/1.png',
    'http://construyaalcosto.storebow.scoutframe.com/assets/store/templates/construyaalcosto/2.png',
    'http://construyaalcosto.storebow.scoutframe.com/assets/store/templates/construyaalcosto/3.png',
  ];
  List<Product> productsMostSaled = [];
  List<Product> productsOnSale = [];
  bool isLoading = true;
  bool canShowDialog = true;
  Box box;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  _getProducts() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DialogsConnections.showLoadingDialog(context);
    });
    final Response response =
        await Connections().get(Connections.PRODUCTS_MOST_SALED);
    final Response response1 =
        await Connections().get(Connections.PRODUCTS_ON_SALE);
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      setState(() {
        productsMostSaled =
            List<Product>.from(response.data.map((x) => Product.fromJson(x)));
        productsOnSale =
            List<Product>.from(response1.data.map((x) => Product.fromJson(x)));
      });
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(context, _getProducts, () {
        exit(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ListView(
        children: [
          ImageSwiper(
            height: 200,
            width: double.infinity,
            images: banners,
          ),
          ListadoProductos(
            orientacion: ListadoProductos.HORIZONTAL,
            context: context,
            title: 'Productos en Oferta',
            products: productsOnSale,
          ),
          ListadoProductos(
            orientacion: ListadoProductos.HORIZONTAL,
            title: 'Lo más vendido',
            products: productsMostSaled,
            context: context,
          ),
        ],
      ),
    );
  }
}
