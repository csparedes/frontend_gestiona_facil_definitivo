import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/categoria.dart';
import 'package:provider/provider.dart';

class AlertDialogDeleteCategoria {
  static showAlertDialog(BuildContext context, String cadena) {
    //split de la cadena
    final split = cadena.split('_');
    final id = split[0];
    final nombre = split[1];

    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () async {
        //Eliminar Usuario
        final categoriaProvider =
            Provider.of<CategoriaProvider>(context, listen: false);
        final peticion = await categoriaProvider.borrarCategoria(id);

        if (peticion['ok']) {
        } else {}
      },
    );

    Widget cancelButton = CupertinoButton(
      child: Text("Cancelar"),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Eliminar Categoria"),
      content: Column(
        children: [
          Text(
              "¿Esta seguro que desea eliminar la categoría $nombre de Gestiona Facil?"),
        ],
      ),
      actions: [
        okButton,
        cancelButton,
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

class AlertDialogOkEditarCategoria {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Edición correcta"),
      content: Column(
        children: [
          Text("La categoría se ha editado correctamente"),
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

class AlertDialogFailEditarCategoria {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Edición Fallida"),
      content: Column(
        children: [
          Text("La categoría no se ha podido editar"),
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

class AlertDialogOkCrearCategoria {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Creación con éxito"),
      content: Column(
        children: [
          Text("La categoría se ha creado correctamente"),
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

class AlertDialogFailCrearCategoria {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Creación Fallida"),
      content: Column(
        children: [
          Text("La categoría no se ha podido crear"),
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
