import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gestionafacil_v3/models/usuario.dart';
import 'package:gestionafacil_v3/providers/usuarios.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/usuarios.dart';
import 'package:provider/provider.dart';

class UsuarioNuevoPage extends StatefulWidget {
  const UsuarioNuevoPage({Key? key}) : super(key: key);

  @override
  State<UsuarioNuevoPage> createState() => _UsuarioNuevoPageState();
}

class _UsuarioNuevoPageState extends State<UsuarioNuevoPage> {
  final formKey = GlobalKey<FormState>();

  UsuarioModel usuario = new UsuarioModel(
    nombre: '',
    roleId: '1',
    email: '',
    password: '',
  );
  @override
  Widget build(BuildContext context) {
    final stringUser = ModalRoute.of(context)!.settings.arguments;
    if (stringUser != null) {
      final split = stringUser.toString().split('-');
      usuario.id = split[0];
      usuario.nombre = split[1];
      usuario.email = split[2];
      usuario.roleId = (split[3] == 'ADMIN') ? '1' : '2';

      return _scaffoldEditarUsuario(context, usuario);
    }
    return _scaffoldNuevoUsuario(context);
  }

  Scaffold _scaffoldNuevoUsuario(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.deepPurple,
          ),
          middle: Text('Nuevo Usuario'),
          border: Border(bottom: BorderSide(width: 1)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _nombre(usuario.nombre),
                  SizedBox(height: 5),
                  _rol(),
                  SizedBox(height: 5),
                  _email(usuario.email),
                  SizedBox(height: 5),
                  _password(),
                  SizedBox(height: 15),
                  _botonCrear(context),
                ],
              ),
            ),
          ),
        ));
  }

  Scaffold _scaffoldEditarUsuario(BuildContext context, UsuarioModel usuario) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.deepPurple,
          ),
          middle: Text('Editar Usuario'),
          border: Border(bottom: BorderSide(width: 1)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _nombre(usuario.nombre),
                  SizedBox(height: 5),
                  _rol(),
                  SizedBox(height: 5),
                  _email(usuario.email),
                  SizedBox(height: 5),
                  _password(),
                  SizedBox(height: 15),
                  _botonEditar(context),
                ],
              ),
            ),
          ),
        ));
  }

  _nombre(String nombre) {
    return TextFormField(
      initialValue: (nombre == '') ? '' : nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.deepPurple),
        labelText: 'Nombre',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese los nombres completos',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => usuario.nombre = value.toString(),
    );
  }

  _rol() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.work_outline, color: Colors.deepPurple),
          SizedBox(width: 15),
          Text(
            'Rol',
            style: TextStyle(color: Colors.deepPurple),
          ),
          Expanded(child: SizedBox()),
          Icon(Icons.unfold_more),
          Container(
            width: 200,
            child: CupertinoPicker(
              looping: true,
              diameterRatio: 0.1,
              itemExtent: 50,
              onSelectedItemChanged: (int index) =>
                  usuario.roleId = (index + 1).toString(),
              children: [
                Text(
                  'ADMIN',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'WORKER',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _email(String email) {
    return TextFormField(
      initialValue: (email == '') ? '' : email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'ejemplo@correo.com',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => usuario.email = value.toString(),
    );
  }

  _password() {
    return TextFormField(
      initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese una contraseña segura',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => usuario.password = value.toString(),
    );
  }

  _botonCrear(BuildContext context) {
    return CupertinoButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Guardar'),
      ),
      onPressed: () => _guardarCrear(context),
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
    final usuariosProvider =
        Provider.of<UsuariosProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await usuariosProvider.crearUsuario(usuario);

    if (peticion['ok']) {
      print(peticion['msg']);
      print(peticion['usuario']['password']);
      AlertDialogUsuarioCreado.showAlertDialog(
          context, peticion['usuario']['nombre']);
    } else {
      // print(peticion['msg']);
      print(peticion['msg']);
      AlertDialogUsuarioCreadoFail.showAlertDialog(context, peticion['msg']);
    }
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
    final usuariosProvider =
        Provider.of<UsuariosProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await usuariosProvider.editarUsuario(usuario.id, usuario);

    if (peticion['ok']) {
      print(peticion['msg']);
      print(peticion['usuario']['password']);
      AlertDialogOkEditUsuarioWidget.showAlertDialog(context);
    } else {
      // print(peticion['msg']);
      print(peticion['msg']);
      AlertDialogFailEditUsuarioWidget.showAlertDialog(context);
    }
  }
}
