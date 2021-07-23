import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogDonacionRealizada {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Donación Realizada con éxito"),
      content: Column(
        children: [
          Text("Se ha realizado la donación con éxito"),
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

class AlertDialogConsumoRealizado {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Consumo realizado con éxito"),
      content: Column(
        children: [
          Text("Se ha realizado el consumo con éxito"),
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
