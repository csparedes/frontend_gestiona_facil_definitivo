import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:provider/provider.dart';

class AlertDialogDeleteClienteWidget {
  static showAlertDialog(BuildContext context, String cadena) {
    //split de la cadena
    final split = cadena.split('_');
    final nombre = split[1];
    final identificacion = split[2];

    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () async {
        //Eliminar Usuario
        final usuarioProvider =
            Provider.of<ClienteProvider>(context, listen: false);
        final peticion = await usuarioProvider.borrarCliente(identificacion);

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
      title: Text("Eliminar Usuario"),
      content: Column(
        children: [
          Text(
              "¿Esta seguro que desea elimnar a $nombre como usuario de Gestiona Facil?"),
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

class AlertDialogOkDeleteClienteWidget {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Cliente Borrado"),
      content: Text("Se ha borrado el cliente"),
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

class AlertDialogFailDeleteClienteWidget {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Error"),
      content: Text("No se pudo eliminar el cliente"),
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

class AlertDialogOkEditClienteWidget {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Cliente Actualizado"),
      content: Text("El cliente se ha actualizado"),
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

class AlertDialogFailEditClienteWidget {
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
      title: Text("Error"),
      content: Text("No se pudo actualizar el cliente"),
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
