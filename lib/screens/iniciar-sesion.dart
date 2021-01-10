import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/login-serveice.dart';
import 'package:construyaalcosto/services/message-serveice.dart';
import 'package:construyaalcosto/widgets/text-field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:form_validator/form_validator.dart';

class IniciarSesion extends StatefulWidget {
  IniciarSesion({Key key}) : super(key: key);

  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userController;
  TextEditingController passwordController;
  final userValidator = ValidationBuilder().minLength(1, 'Debe llenar el campo').email('El usuario no es valido').build();
  final passwordValidator =
      ValidationBuilder().minLength(1, 'Debe llenar el campo').minLength(6, 'La contraseña debe tener al menos 6 caracteres').build();

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
  }

  void _login(BuildContext context) async {
    var data = json.encode({"username": "${userController.text}", "password": "${passwordController.text}", "role": "CUSTOMER"});
    DialogsConnections.showLoadingDialog(context);
    Response response = await Connections().post(Connections.LOGIN, data);
    if (response != null && response.statusCode == 200) {
      if (response.data['id'] != null) {
        Login login = Login.fromJson(response.data);
        LoginService().addLogin(login);
        Navigator.of(context).pop();
      } else {
        MessageService.showMessage(
          context: context,
          isNegative: true,
          mensaje: 'Ha ocurrido un problema. Revise los datos introducidos',
        );
      }
      DialogsConnections.hideLoadingDialog(context);
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(context, () {
        _login(context);
      }, () {});
      print('error');
    }
  }

  _validateForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _login(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            iconRequired: false,
                            controller: userController,
                            label: 'Usuario',
                            validator: userValidator,
                          ),
                          CustomTextField(
                            iconRequired: false,
                            controller: passwordController,
                            label: 'Contraseña',
                            obscureText: true,
                            validator: passwordValidator,
                          ),
                          Builder(
                            builder: (context) => SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _validateForm(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                          textColor: Theme.of(context).accentColor,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'OLVIDE MI CONTRASEÑA',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('¿Eres nuevo por aquí?'),
                            FlatButton(
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              textColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'REGISTRARSE',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () async {
                                await Navigator.of(context).pushNamed('/registrarse');
                                if (LoginService().isLogin()) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('¿No quieres registrarte ahora?'),
                            FlatButton(
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              textColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'MÁS TARDE',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
