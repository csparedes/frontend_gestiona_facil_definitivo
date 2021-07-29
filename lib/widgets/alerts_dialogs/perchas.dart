import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/providers/perchar.dart';
import 'package:provider/provider.dart';

class AlertDialogOkEditPercha {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Percha Actualizada"),
      content: Text("La percha se ha actualizado"),
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

class AlertDialogFailEditPercha {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Error"),
      content: Text("La percha no se pudo actualizar"),
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

class AlertDialogDeletePercha {
  static showAlertDialog(BuildContext context, String cadena) {
    //split de la cadena
    final split = cadena.split('-');

    final id = split[0];

    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () async {
        //Eliminar Usuario
        final productoProvider =
            Provider.of<PercharProvider>(context, listen: false);
        final peticion = await productoProvider.borrarPercha(id);

        if (peticion['ok']) {
          // AlertDialogOkDeleteUsuarioWidget.showAlertDialog(context);
          AlertDialogOkDeletePercha.showAlertDialog(context);
        } else {
          // AlertDialogFailDeleteUsuarioWidget.showAlertDialog(context);
          AlertDialogFailDeletePercha.showAlertDialog(context);
        }
      },
    );

    Widget cancelButton = CupertinoButton(
      child: Text(
        "Cancelar",
        style: TextStyle(color: CupertinoColors.destructiveRed),
      ),
      onPressed: () => Navigator.pop(context),
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Eliminar Usuario"),
      content: Column(
        children: [
          Text(
              "¿Esta seguro que desea elimnar el enlace de perchas y artículos?"),
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

class AlertDialogOkDeletePercha {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Producto Borrado"),
      content: Text("Se ha borrado el producto"),
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

class AlertDialogFailDeletePercha {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
