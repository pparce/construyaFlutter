import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/services/login-serveice.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VistaCustomer extends StatefulWidget {
  VistaCustomer({Key key}) : super(key: key);

  @override
  _VistaCustomerState createState() => _VistaCustomerState();
}

class _VistaCustomerState extends State<VistaCustomer> {
  Login login;

  _logout() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estas seguro desea cerrar sesión?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCELAR'),
            ),
            FlatButton(
              onPressed: () {
                LoginService().logout();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('CERRAR SESIÓN'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Usuario'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _logout();
              },
            )
          ],
        ),
        body: Builder(
          builder: (context) {
            final loginService = Provider.of<LoginService>(context);
            login = loginService.getLogin();
            return login.id != null
                ? Container(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      children: [
                        _getLoginHeader(login),
                        SizedBox(
                          height: 8,
                        ),
                        _getBillingInformation(login),
                        SizedBox(
                          height: 8,
                        ),
                        _getShippingInformation(login),
                        SizedBox(
                          height: 8,
                        ),
                        _getAccesInformatoin(),
                        SizedBox(
                          height: 8,
                        ),
                        _getLibretaDirecciones(),
                        SizedBox(
                          height: 8,
                        ),
                        _getListaPedidos(),
                      ],
                    ),
                  )
                : Container();
          },
        ));
  }

  Widget _getBillingInformation(Login login) {
    CustomerIngInformation customerBillingInformation =
        login.customer.customerBillingInformation;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextTitle(
                      margin: EdgeInsets.only(bottom: 16),
                      text: 'Información de Pago',
                    ),
                  ),
                  Icon(Icons.edit)
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      TextTitle(
                        text: 'Nombre: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.firstName,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Apellidos: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.lastName,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Teléfono: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.phone,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'País: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.country.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Estado: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.state.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Ciudad: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.city.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Dirección: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerBillingInformation.address,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getShippingInformation(Login login) {
    CustomerIngInformation customerShippingInformation =
        login.customer.customerShippingInformation;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextTitle(
                      margin: EdgeInsets.only(bottom: 16),
                      text: 'Información de Envío',
                    ),
                  ),
                  Icon(Icons.edit),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      TextTitle(
                        text: 'Nombre: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.firstName,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Apellidos: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.lastName,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Teléfono: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.phone,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'País: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.country.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Estado: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.state.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Ciudad: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.city.name,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      TextTitle(
                        text: 'Dirección: ',
                        fontSize: 15,
                      ),
                      TextSubTitle(
                        text: customerShippingInformation.address,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAccesInformatoin() {
    CustomerIngInformation customerShippingInformation =
        login.customer.customerShippingInformation;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: () {
          Navigator.of(context).pushNamed('/informacion-acceso');
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextTitle(
                      text: 'Información de Acceso',
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 28,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLibretaDirecciones() {
    CustomerIngInformation customerShippingInformation =
        login.customer.customerShippingInformation;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: () {
          Navigator.of(context).pushNamed('/libreta-direcciones');
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextTitle(
                      text: 'Libreta de Direcciones',
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 28,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListaPedidos() {
    CustomerIngInformation customerShippingInformation =
        login.customer.customerShippingInformation;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: () {
          Navigator.of(context).pushNamed('/pedidos');
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextTitle(
                      text: 'Lista de Pedidos',
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 28,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLoginHeader(Login login) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          child: Text(
            login.customer.user.firstName[0].toUpperCase(),
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).accentColor,
        ),
        SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${login.customer.user.firstName} ${login.customer.user.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              login.customer.user.email,
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
