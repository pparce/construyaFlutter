import 'package:construyaalcosto/models/cart.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';

class TablaTotales extends StatelessWidget {
  final Cart cart;
  const TablaTotales({Key key, this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: Container(
        width: 200,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(width: 0.3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSubTitle(
                    fontSize: 14,
                    text: 'SUBTOTAL',
                  ),
                  TextSubTitle(
                    fontSize: 14,
                    text: '\$' + cart.total.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSubTitle(
                    fontSize: 14,
                    text: 'DESCUENTO',
                  ),
                  TextSubTitle(
                    fontSize: 14,
                    text: '\$00,00',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSubTitle(
                    fontSize: 14,
                    text: 'ENVIO',
                  ),
                  TextSubTitle(
                    fontSize: 14,
                    text: '\$00,00',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTitle(
                    fontSize: 16,
                    text: 'TOTAL',
                  ),
                  TextTitle(
                    fontSize: 16,
                    text: '\$' + cart.total.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
