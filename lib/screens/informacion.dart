import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';

class Informacion extends StatelessWidget {
  const Informacion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextTitle(
              text: 'CONTRUYA AL COSTO',
            ),
            TextSubTitle(
              text:
                  'Es una empresa del Grupo Pose dedicada a la venta de materiales para la construcción y a la fabricación de productos de herrería, aberturas, carpintería métalica y de madera.',
            ),
          ],
        ),
      ),
    );
  }
}
