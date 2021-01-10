import 'package:colour/colour.dart';
import 'package:construyaalcosto/models/login.dart';
import 'package:construyaalcosto/screens/buscar.dart';
import 'package:construyaalcosto/screens/carro/carro.dart';
import 'package:construyaalcosto/screens/informacion-acceso.dart';
import 'package:construyaalcosto/screens/libreta-direcciones.dart';
import 'package:construyaalcosto/screens/pedidos.dart';
import 'package:construyaalcosto/screens/vista-customer.dart';
import 'package:construyaalcosto/screens/favoritos.dart';
import 'package:construyaalcosto/screens/informacion.dart';
import 'package:construyaalcosto/screens/iniciar-sesion.dart';
import 'package:construyaalcosto/screens/principal/principal.dart';
import 'package:construyaalcosto/screens/productos.dart';
import 'package:construyaalcosto/screens/registrarse.dart';
import 'package:construyaalcosto/screens/vista-image.dart';
import 'package:construyaalcosto/screens/vista-producto.dart';
import 'package:construyaalcosto/services/carrito-service.dart';
import 'package:construyaalcosto/services/login-serveice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    StatusbarUtil.setTranslucent();
    StatusbarUtil.setStatusBarFont(FontStyle.black);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return ChangeNotifierProvider(
      create: (_) => CarroService(),
      child: ChangeNotifierProvider(
        create: (_) => LoginService(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            accentColor: Colour('#1872CC'),
            focusColor: Colour('#1872CC'),
            primaryColor: Colors.white,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: Principal(),
          initialRoute: '/',
          routes: {
            '/': (BuildContext context) => Principal(),
            '/vista-producto': (BuildContext context) => VistaProducto(),
            '/vista-image': (BuildContext context) => VistaImage(),
            '/buscar': (BuildContext context) => Buscar(),
            '/favoritos': (BuildContext context) => Favoritos(),
            '/productos': (BuildContext context) => Productos(),
            '/iniciar-sesion': (BuildContext context) => IniciarSesion(),
            '/registrarse': (BuildContext context) => Registrarse(),
            '/carro': (BuildContext context) => Carro(),
            '/informacion': (BuildContext context) => Informacion(),
            '/vista-customer': (BuildContext context) => VistaCustomer(),
            '/informacion-acceso': (BuildContext context) =>
                InformacionAcceso(),
            '/libreta-direcciones': (BuildContext context) =>
                LibretaDirecciones(),
            '/pedidos': (BuildContext context) => Pedidos(),
          },
        ),
      ),
    );
  }
}
