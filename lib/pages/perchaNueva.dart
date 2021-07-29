import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/percha.dart';
import 'package:gestionafacil_v3/providers/perchar.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/perchas.dart';
import 'package:provider/provider.dart';

class PerchaNuevaPage extends StatefulWidget {
  const PerchaNuevaPage({Key? key}) : super(key: key);

  @override
  _PerchaNuevaPageState createState() => _PerchaNuevaPageState();
}

class _PerchaNuevaPageState extends State<PerchaNuevaPage> {
  final formKey = GlobalKey<FormState>();
  PerchaModel percha = new PerchaModel(cajaId: '', articuloId: '');
  @override
  Widget build(BuildContext context) {
    final stringPercha = ModalRoute.of(context)!.settings.arguments;
    if (stringPercha != null) {
      final split = stringPercha.toString().split('-');
      percha.id = int.parse(split[0]);
      percha.cajaId = split[1];
      percha.articuloId = split[2];
      //editar
      return _scaffoldEditarPercha(context, percha);
    }
    //crear
    return _scaffoldCrearPercha(context, percha);
  }

  _scaffoldEditarPercha(BuildContext context, PerchaModel percha) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Editar Percha'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _cajaId(percha.cajaId),
                SizedBox(height: 5),
                _articuloId(percha.articuloId),
                SizedBox(height: 5),
                _botonEditar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cajaId(String nombre) {
    return TextFormField(
      initialValue: (nombre == '') ? null : nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.rice_bowl_outlined, color: Colors.deepPurple),
        labelText: 'Caja',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese la caja del producto',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => percha.cajaId = value.toString(),
    );
  }

  _articuloId(String nombre) {
    return TextFormField(
      initialValue: (nombre == '') ? null : nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.rice_bowl_outlined, color: Colors.deepPurple),
        labelText: 'Artículo',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese el artículo',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => percha.articuloId = value.toString(),
    );
  }

  _botonEditar(BuildContext context) {
    return CupertinoButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Guardar'),
      ),
      onPressed: () => _guardarEditar(context),
      color: Colors.deepPurple,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  _guardarEditar(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    //En este punto el usuario tiene los 4 datos principales

    //enviamos al provider
    // UsuariosProvider usuariosProvider = new UsuariosProvider();
    final perchasProvider =
        Provider.of<PercharProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion =
        await perchasProvider.editarPerchaNueava(percha.id.toString(), percha);

    if (peticion['ok']) {
      AlertDialogOkEditPercha.showAlertDialog(context);
    } else {
      AlertDialogFailEditPercha.showAlertDialog(context);
    }
  }

  _scaffoldCrearPercha(BuildContext context, PerchaModel percha) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Crear Percha'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _cajaId(percha.cajaId),
                SizedBox(height: 5),
                _articuloId(percha.articuloId),
                SizedBox(height: 15),
                _botonCrear(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _botonCrear(BuildContext context) {
    return CupertinoButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Guardar'),
      ),
      onPressed: () => _guardarCrear(context)(context),
      color: Colors.deepPurple,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  _guardarCrear(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    //En este punto el usuario tiene los 4 datos principales

    //enviamos al provider
    // UsuariosProvider usuariosProvider = new UsuariosProvider();
    final perchasProvider =
        Provider.of<PercharProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await perchasProvider.crearPerchaNueava(percha);

    if (peticion['ok']) {
      AlertDialogOkCrearPercha.showAlertDialog(context);
    } else {
      AlertDialogFailCrearPercha.showAlertDialog(context);
    }
  }
}

class AlertDialogOkCrearPercha {
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
      title: Text("Enlace de percha creado"),
      content: Text("Se ha creado un nuevo enlace de productos caja-artículo"),
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

class AlertDialogFailCrearPercha {
  static showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Error"),
      content: Text('No se pudo crear el enlace de percha'),
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
