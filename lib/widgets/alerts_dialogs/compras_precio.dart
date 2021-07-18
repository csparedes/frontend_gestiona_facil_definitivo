import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/compras.dart';

class AlertDialogEditarPrecioCompra {
  static showAlertDialog(
      BuildContext context, ComprasProvider comprasProvider, String codigo) {
    String precio = '0.00';
    Widget okButton = CupertinoButton(
      child: Text('Ok'),
      onPressed: () {
        comprasProvider.modificarPrecio(codigo, precio);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = CupertinoButton(
        child: Text('Cancelar'), onPressed: () => Navigator.pop(context));

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Modificar precio de compra'),
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Precio de Compra'),
              onChanged: (value) => precio = value.toString(),
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

class AlertDialogEditarCantidadCompra {
  static showAlertDialog(
      BuildContext context, ComprasProvider comprasProvider, String codigo) {
    String cantidad = '0.00';
    Widget okButton = CupertinoButton(
      child: Text('Ok'),
      onPressed: () {
        comprasProvider.modificarCantidad(codigo, cantidad);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = CupertinoButton(
        child: Text('Cancelar'), onPressed: () => Navigator.pop(context));

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Modificar cantidad de compra'),
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
