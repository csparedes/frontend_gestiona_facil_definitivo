import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogVentaRealizada {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Venta Realizada"),
      content: Column(
        children: [
          Text("La venta se ha realizado con éxito"),
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
