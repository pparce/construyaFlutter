import 'package:construyaalcosto/models/category.dart';
import 'package:construyaalcosto/models/product.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/widgets/listado-productos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

class Productos extends StatefulWidget {
  Productos({Key key}) : super(key: key);

  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  Categorie categorie;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getProductByCategory();
    });
  }

  _getProductByCategory() async {
    DialogsConnections.showLoadingDialog(context);
    final response = await Connections().get(Connections.getUrlById(
        categorie.id, Connections.PRODUCTS_BY_CATEGORIES));
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      setState(() {
        products = List<Product>.from(
            response.data['products'].map((x) => Product.fromJson(x)));
      });
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(
        context,
        _getProductByCategory,
        () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    categorie = ModalRoute.of(context).settings.arguments;
    final carroService = Provider.of<CarroService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categorie.name),
        actions: [
          AnimatedContainer(
            padding: EdgeInsets.only(top: 9, bottom: 9, right: 8),
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            transform: Matrix4.translationValues(
                carroService.isCartEmpty() ? 150 : 0, 0, 0),
            // width: carroService.isCartEmpty() ? 0 : 120,
            height: 50,
            child: carroService.isCartEmpty()
                ? Container()
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/carro');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('\$' +
                            carroService.getCartTotal().toStringAsFixed(2)),
                      ],
                    ),
                  ),
          )
        ],
      ),
      body: Container(
          child: Builder(
        builder: (context) => ListadoProductos(
          orientacion: ListadoProductos.VERTICAL,
          context: context,
          title: '',
          products: products,
        ),
      )),
    );
  }
}
