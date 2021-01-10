import 'package:construyaalcosto/models/cart.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/widgets/listado-productos-carrito.dart';
import 'package:construyaalcosto/widgets/tabla-totales.dart';
import 'package:construyaalcosto/widgets/text-disabled.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarroProducto extends StatefulWidget {
  CarroProducto({Key key}) : super(key: key);

  @override
  _CarroProductoState createState() => _CarroProductoState();
}

class _CarroProductoState extends State<CarroProducto> {
  CarroService carroService;

  @override
  void initState() {
    super.initState();
    carroService = CarroService();
  }

  _showItemBottomSheet(Item item) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitle(
                  margin: EdgeInsets.all(16),
                  text: 'Opciones:',
                ),
                ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Eliminar'),
                  onTap: () {
                    Navigator.pop(context);
                    carroService.removeItem(item);
                    if (carroService.getItemsCart().length == 0) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final carroService = Provider.of<CarroService>(context);
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            child: TextDisabled(
              text: 'Mantén presionado para más opciones',
            ),
          ),
          Expanded(
            child: ListadoProductosCarrito(
              cart: carroService.getCart(),
              onLongPress: (item) {
                _showItemBottomSheet(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
