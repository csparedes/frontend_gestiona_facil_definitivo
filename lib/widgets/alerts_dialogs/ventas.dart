import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogVentaCamara {
  static showAlertDialog(BuildContext context, Widget child) {
    //Crear Boton
    Widget okButton = CupertinoButton(
      child: Text(
        'Ok',
        style: TextStyle(
          color: CupertinoColors.systemPurple,
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Agregar Producto'),
      content: Container(
        height: 300,
        width: double.infinity,
        color: Colors.amberAccent,
        child: child,
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
