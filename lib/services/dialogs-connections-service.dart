import 'package:flutter/material.dart';

class DialogsConnections {
  static Future<void> showLoadingDialog(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
                children: [
                  Container(
                    width: 500,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Row(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Cargando datos...",
                      )
                    ]),
                  )
                ],
              ));
        });
  }

  static Future<void> showRetryDialog(
      BuildContext context, Function accion, Function cancel) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      cancel();
                    },
                    child: Text('CANCELAR'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      accion();
                    },
                    child: Text('REINTENTAR'),
                  ),
                ],
                content: Container(
                    child: Text(
                        'Error de conexión. Revise su conexión a internet.')),
              ));
        });
  }

  static Future<void> hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
