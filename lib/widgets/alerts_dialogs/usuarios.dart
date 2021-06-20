import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/usuarios.dart';
import 'package:provider/provider.dart';

class AlertDialogUsuarioCreado {
  static showAlertDialog(BuildContext context, String nombre) {
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
      title: Text("Usuario Creado"),
      content: Text("Se ha creado con éxito un nuevo usuario de: $nombre"),
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

class AlertDialogUsuarioCreadoFail {
  static showAlertDialog(BuildContext context, String msg) {
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
      content: Text(msg),
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

class AlertDialogDeleteUsuario {
  static showAlertDialog(BuildContext context, String cadena) {
    //split de la cadena
    final split = cadena.split('-');
    final id = split[0];
    final nombre = split[1];

    // Create button
    Widget okButton = CupertinoButton(
      child: Text("OK"),
      onPressed: () async {
        //Eliminar Usuario
        final usuarioProvider =
            Provider.of<UsuariosProvider>(context, listen: false);
        final peticion = await usuarioProvider.borrarUsuario(id);

        if (peticion['ok']) {
          AlertDialogDeleteUsuarioOk.showAlertDialog(context);
        } else {
          AlertDialogDeleteUsuarioFail.showAlertDialog(context);
        }
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

class AlertDialogOkEditUsuarioWidget {
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
      title: Text("Usuario Actualizado"),
      content: Text("El usuario se ha actualizado"),
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

class AlertDialogFailEditUsuarioWidget {
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
      content: Text("No se pudo actualizar el usuario"),
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

class AlertDialogDeleteUsuarioOk {
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
      title: Text("Usuario Borrado"),
      content: Text("Se ha borrado el usuario"),
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

class AlertDialogDeleteUsuarioFail {
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
      content: Text("No se pudo eliminar el usuario"),
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
