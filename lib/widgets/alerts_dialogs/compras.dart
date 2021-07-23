import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogCompraRealizada {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Compra Realizada"),
      content: Column(
        children: [
          Text(
              "La compra se ha realizado con éxito, y los productos se han ingresado al inventario"),
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
