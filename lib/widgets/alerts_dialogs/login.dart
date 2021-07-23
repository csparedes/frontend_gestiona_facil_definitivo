import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogLoginWidget {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Ha ocurrido algo indeseable"),
      content: Text("Usuario o clave incorrecta"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class AlertDialogContactoAdministracionWidget {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Administración"),
      content: Column(
        children: [
          Text("Visite las instalaciones de Víveres Stalin"),
          Text("Ciudad: Tulcán"),
          Text("Tarqui 3-73 y Sucre"),
          Text("Frente a la plazoleta del Mercado San Miguel"),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
