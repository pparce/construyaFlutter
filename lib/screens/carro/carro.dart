import 'package:construyaalcosto/screens/carro/fragments/carro-envio.dart';
import 'package:construyaalcosto/screens/carro/fragments/carro-pago.dart';
import 'package:construyaalcosto/screens/carro/fragments/carro-producto.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/widgets/stepper.dart';
import 'package:flutter/material.dart';

class Carro extends StatefulWidget {
  Carro({Key key}) : super(key: key);

  @override
  _CarroState createState() => _CarroState();
}

void _clearCarro(BuildContext context) {
  showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Limpiar Carro de Compras'),
        content: Text('¿Estas seguro de querer limpiar el Carro de Compras?'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCELAR'),
          ),
          FlatButton(
            onPressed: () {
              CarroService().clearCart();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('LIMPIAR'),
          ),
        ],
      ));
}

class _CarroState extends State<Carro> {
  int currentStep = 0;
  bool continuar = true;

  _onPreviusTap() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  _onNextTap() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Carro de Compras'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              _clearCarro(context);
            },
          ),
        ],
      ),
      body: CustomStepper(
        controlsBuilder: (context, {onStepCancel, onStepContinue}) {
          continuar = currentStep != 1;
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: currentStep > 0,
                  child: FlatButton(
                    onPressed: () {
                      _onPreviusTap();
                    },
                    child: Text('ATRAS'),
                  ),
                ),
                currentStep < 2
                    ? FlatButton(
                        onPressed: continuar
                            ? () {
                                _onNextTap();
                              }
                            : null,
                        child: Text('CONTINUAR'),
                      )
                    : FlatButton(
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _onNextTap();
                        },
                        child: Text('FINALIZAR'),
                      )
              ],
            ),
          );
        },
        type: CustomStepperType.horizontal,
        currentStep: currentStep,
        steps: [
          CustomStep(
            title: Text('Productos'),
            content: CarroProducto(),
            isActive: true,
          ),
          CustomStep(
            title: Text('Envío'),
            content: CarroEnvio(),
            isActive: currentStep > 0,
          ),
          CustomStep(
            title: Text('Pago'),
            content: CarroPago(),
            isActive: currentStep > 1,
          ),
        ],
      ),
    );
  }
}
