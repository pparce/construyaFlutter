import 'dart:async';

import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/screens/principal/fragments/categorias.dart';
import 'package:construyaalcosto/screens/principal/fragments/inicio.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/services/login-serveice.dart';
import 'package:construyaalcosto/widgets/item_drawer.dart';
import 'package:construyaalcosto/widgets/text-subtitle.dart';
import 'package:construyaalcosto/widgets/text-title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Principal extends StatefulWidget {
  Principal({Key key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String title;
  Widget fragment;
  int _drawerItemIndex = 0;
  bool canExit = false;
  final _scaffKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    title = 'Inicio';
    fragment = InicioFragment();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onDrawerTap(String menu) {
    Navigator.of(context).pop();
    switch (menu) {
      case 'Inicio':
        setState(() {
          title = 'Inicio';
          fragment = InicioFragment();
          _drawerItemIndex = 0;
        });
        break;
      case 'Categorias':
        setState(() {
          title = 'Categorias';
          fragment = CategoriesFragment(
            backPress: () {
              _onBackPressed(context);
            },
          );
          _drawerItemIndex = 1;
        });
        break;
      case 'Favoritos':
        Navigator.of(context).pushNamed('/favoritos');
        break;
      case 'Informacion':
        Navigator.of(context).pushNamed('/informacion');
        break;
    }
  }

  Widget _drawer() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 16),
          children: <Widget>[
            _drawerHeader(false),
            ItemDrawer(
                title: 'Inicio',
                background: Theme.of(context).accentColor,
                selected: title == 'Inicio',
                icon: Icons.home,
                onTap: () {
                  _onDrawerTap('Inicio');
                }),
            ItemDrawer(
              title: 'Categorias',
              background: Theme.of(context).accentColor,
              selected: title == 'Categorias',
              icon: Icons.local_mall,
              onTap: () {
                _onDrawerTap('Categorias');
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ItemDrawer(
              title: 'Favoritos',
              background: Theme.of(context).accentColor,
              icon: Icons.favorite,
              onTap: () {
                _onDrawerTap('Favoritos');
              },
            ),
            ItemDrawer(
              title: 'Información',
              background: Theme.of(context).accentColor,
              icon: Icons.info,
              onTap: () {
                _onDrawerTap('Informacion');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader(bool isLoged) {
    return Builder(
      builder: (BuildContext context) {
        final loginService = Provider.of<LoginService>(context);
        isLoged = loginService.isLogin();
        Login login = loginService.getLogin();
        loginService.showWelcomeMessage(context);
        return Container(
          child: isLoged
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/vista-customer');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: Text(
                            login.customer.user.firstName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(login.customer.user.email),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(5)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/iniciar-sesion');
                        },
                        child: Text('INICIAR SESIÓN'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  bool _onBackPressed(BuildContext context) {
    // print(canExit);
    if (_drawerItemIndex == 0) {
      if (canExit) {
        return true;
      } else {
        setState(() {
          canExit = true;
        });
        Timer(const Duration(milliseconds: 2000), () {
          setState(() {
            canExit = false;
          });
        });
        final snackBar = SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Text('Presione una vez más para cerrar'),
        );
        _scaffKey.currentState.showSnackBar(snackBar);

        return false;
      }
    } else {
      setState(() {
        title = 'Inicio';
        fragment = InicioFragment();
        _drawerItemIndex = 0;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
      },
      child: Scaffold(
        key: _scaffKey,
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed('/buscar');
              },
            ),
            Builder(
              builder: (context) {
                final carroService = Provider.of<CarroService>(context);
                final loginService = Provider.of<LoginService>(context);
                loginService.showWelcomeMessage(context);
                return AnimatedContainer(
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
                                  carroService
                                      .getCartTotal()
                                      .toStringAsFixed(2)),
                            ],
                          ),
                        ),
                );
              },
            ),
          ],
        ),
        drawer: _drawer(),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: fragment,
        ),
      ),
    );
  }
}
