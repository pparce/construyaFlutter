import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/login-serveice.dart';
import 'package:construyaalcosto/services/message-serveice.dart';
import 'package:construyaalcosto/widgets/empty-screen.dart';
import 'package:construyaalcosto/widgets/text-field.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class CarroEnvio extends StatefulWidget {
  CarroEnvio({Key key}) : super(key: key);

  @override
  _CarroEnvioState createState() => _CarroEnvioState();
}

class _CarroEnvioState extends State<CarroEnvio> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email, password, firstName, lastName, address, zipCode, country, state, city, phone, tax;
  final userValidator = ValidationBuilder().minLength(1, 'Debe llenar el campo').email('El usuario no es valido').build();
  final passwordValidator =
      ValidationBuilder().minLength(1, 'Debe llenar el campo').minLength(6, 'La contraseña debe tener al menos 6 caracteres').build();
  final fieldValidator = ValidationBuilder().minLength(1, 'Debe llenar el campo').build();
  List<Country> paises = [];
  List<Country> estados = [];
  List<Country> ciudades = [];
  Country pais = Country();
  Country estado = Country();
  Country ciudad = Country();

  @override
  void initState() {
    super.initState();

    _initFilds();
    LoginService().addListener(() {
      _initFilds();
    });
  }

  _initFilds() {
    if (LoginService().isLogin()) {
      CustomerIngInformation shippingInformation = LoginService().getLogin().customer.customerShippingInformation;
      pais = shippingInformation.country;
      estado = shippingInformation.state;
      ciudad = Country(
        id: shippingInformation.city.id,
        name: shippingInformation.city.name,
        name2: shippingInformation.city.name2,
      );
      firstName = TextEditingController(text: shippingInformation.firstName);
      lastName = TextEditingController(text: shippingInformation.lastName);
      address = TextEditingController(text: shippingInformation.address);
      zipCode = TextEditingController(text: shippingInformation.zipCode);
      country = TextEditingController(text: shippingInformation.country.name);
      state = TextEditingController(text: shippingInformation.state.name);
      city = TextEditingController(text: shippingInformation.city.name);
      phone = TextEditingController(text: shippingInformation.phone);
      tax = TextEditingController(text: shippingInformation.tax);
    } else {
      firstName = TextEditingController();
      lastName = TextEditingController();
      address = TextEditingController();
      zipCode = TextEditingController();
      country = TextEditingController();
      state = TextEditingController();
      city = TextEditingController();
      phone = TextEditingController();
      tax = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    address.dispose();
    zipCode.dispose();
    country.dispose();
    state.dispose();
    city.dispose();
    phone.dispose();
    tax.dispose();
  }

  void _getCountry() async {
    DialogsConnections.showLoadingDialog(context);
    Response response = await Connections().get(Connections.PAISES);
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      paises = List<Country>.from(response.data.map((x) => Country.fromJson(x)));
      _showCountryModal('Listado de Paises: ', paises, (Country value) {
        estado = Country();
        ciudad = Country();
        pais = value;
        country.text = value.name;
        state.text = '';
        city.text = '';
        setState(() {});
      });
    } else {
      DialogsConnections.hideLoadingDialog(context);
    }
  }

  void _getState() async {
    DialogsConnections.showLoadingDialog(context);
    Response response = await Connections().get(Connections.getUrlById(pais.id, Connections.PROVINCIAS));
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      estados = List<Country>.from(response.data.map((x) => Country.fromJson(x)));
      _showCountryModal('Listado de Estados: ', estados, (Country value) {
        ciudad = Country();
        estado = value;
        state.text = value.name;
        city.text = '';
        setState(() {});
      });
    } else {
      DialogsConnections.hideLoadingDialog(context);
    }
  }

  void _getCity() async {
    DialogsConnections.showLoadingDialog(context);
    Response response = await Connections().get(Connections.getUrlById(estado.id, Connections.CIUDADES));
    if (response != null && response.statusCode == 200) {
      DialogsConnections.hideLoadingDialog(context);
      ciudades = List<Country>.from(response.data.map((x) => Country.fromJson(x)));
      _showCountryModal('Listado de ciudades: ', ciudades, (Country value) {
        ciudad = value;
        city.text = value.name;
        setState(() {});
      });
    } else {
      DialogsConnections.hideLoadingDialog(context);
    }
  }

  void _showCountryModal(String title, List<Country> listado, Function onTap) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Container(
          width: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listado.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(listado[index].name),
              onTap: () {
                onTap(listado[index]);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _registrarse(context);
    }
  }

  void _registrarse(BuildContext context) async {
    DialogsConnections.showLoadingDialog(context);
    Response response = await Connections().post(Connections.REGISTRO, buildJSON());
    if (response != null && response.statusCode == 200) {
      print(response.data);
      if (response.data['id'] != null) {
        Login login = Login.fromJson(response.data);
        LoginService().addLogin(login);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        DialogsConnections.hideLoadingDialog(context);
        MessageService.showMessage(
          context: context,
          isNegative: true,
          mensaje: response.data['detail'],
        );
      }
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(context, _registrarse, () {});
    }
  }

  String buildJSON() {
    var data = json.encode({
      "customer": {
        "customer_billing_information": {
          "address": address.text,
          "city": ciudad.id,
          "country": pais.id,
          "first_name": firstName.text,
          "last_name": lastName.text,
          "phone": phone.text,
          "state": estado.id,
          "tax": tax.text,
          "zip_code": zipCode.text,
        },
        "customer_shipping_information": {
          "address": address.text,
          "city": ciudad.id,
          "country": pais.id,
          "first_name": firstName.text,
          "last_name": lastName.text,
          "phone": phone.text,
          "state": estado.id,
          "tax": tax.text,
          "zip_code": zipCode.text,
        },
        "email": email.text,
        "password": password.text,
        "enabled": true
      },
      "role": "CUSTOMER"
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginService>(context);
    bool isLogin = loginService.isLogin();
    Login login = loginService.getLogin();
    return Container(
        child: isLogin
            ? CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitle(
                                  margin: EdgeInsets.only(bottom: 16),
                                  text: 'Información Personal',
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextField(
                                        controller: firstName,
                                        validator: fieldValidator,
                                        label: 'Nombre',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextField(
                                        controller: lastName,
                                        validator: fieldValidator,
                                        label: 'Apellidos',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextField(
                                        controller: address,
                                        validator: fieldValidator,
                                        label: 'Dirección',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextField(
                                        controller: zipCode,
                                        validator: fieldValidator,
                                        label: 'Código ZIP',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          _getCountry();
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            controller: country,
                                            validator: fieldValidator,
                                            label: 'País',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: pais.id != null
                                            ? () {
                                                _getState();
                                              }
                                            : null,
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            controller: state,
                                            validator: fieldValidator,
                                            label: 'Estado',
                                            enabled: pais.id != null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: estado.id != null
                                            ? () {
                                                _getCity();
                                              }
                                            : null,
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            controller: city,
                                            validator: fieldValidator,
                                            label: 'Ciudad',
                                            enabled: estado.id != null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  controller: phone,
                                  validator: fieldValidator,
                                  label: 'Teléfono',
                                ),
                                CustomTextField(
                                  controller: tax,
                                  label: 'Impuesto',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),
                ],
              )
            : Container(
                padding: EdgeInsets.all(16),
                child: EmptyScreen(
                  icon: Icons.person_outline,
                  label: 'Para continuar debe Iniciar Sesión.',
                  accion: FlatButton(
                    textColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/iniciar-sesion');
                    },
                    child: Text('INICIAR SESIÓN'),
                  ),
                ),
              ));
  }
}
