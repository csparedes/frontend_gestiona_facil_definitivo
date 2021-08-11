import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';

class AlertDialogEditarCantidadVenta {
  static showAlertDialog(
      BuildContext context, VentasProvider ventasProvider, String codigo) {
    String cantidad = '0.00';
    Widget okButton = CupertinoButton(
      child: Text(
        'Ok',
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        ventasProvider.modificarCantidad(codigo, cantidad);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = CupertinoButton(
      child: Text(
        'Cancelar',
        style: TextStyle(color: CupertinoColors.destructiveRed),
      ),
      onPressed: () => Navigator.pop(context),
    );

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Modificar cantidad de Venta'),
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Cantidad'),
              onChanged: (value) => cantidad = value.toString(),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
