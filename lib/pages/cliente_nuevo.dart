import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/clientes.dart';
import 'package:provider/provider.dart';

class ClienteNuevoPage extends StatefulWidget {
  const ClienteNuevoPage({Key? key}) : super(key: key);

  @override
  _ClienteNuevoPageState createState() => _ClienteNuevoPageState();
}

class _ClienteNuevoPageState extends State<ClienteNuevoPage> {
  final formKey = GlobalKey<FormState>();
  ClienteModel cliente = new ClienteModel(
      nombre: '', identificacion: '', domicilio: '', email: '');
  @override
  Widget build(BuildContext context) {
    final stringCliente = ModalRoute.of(context)!.settings.arguments;
    if (stringCliente != null) {
      final split = stringCliente.toString().split('_');
      // '${cliente.id}_${cliente.nombre}_${cliente.identificacion}_${cliente.domicilio}_${cliente.email}'
      cliente.id = split[0];
      cliente.nombre = split[1];
      cliente.identificacion = split[2];
      cliente.domicilio = split[3];
      cliente.email = split[4];
      return _scaffoldEditarCliente(context, cliente);
    }
    return _scaffoldCrearCliente(context);
  }

  Scaffold _scaffoldCrearCliente(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Crear Cliente'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(cliente.nombre),
                SizedBox(height: 5),
                _identificacion(cliente.identificacion),
                SizedBox(height: 5),
                _domicilio(cliente.domicilio),
                SizedBox(height: 5),
                _email(cliente.email),
                SizedBox(height: 15),
                _botonCrear(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold _scaffoldEditarCliente(BuildContext context, ClienteModel cliente) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Editar Cliente'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(cliente.nombre),
                SizedBox(height: 5),
                _identificacion(cliente.identificacion),
                SizedBox(height: 5),
                _domicilio(cliente.domicilio),
                SizedBox(height: 5),
                _email(cliente.email),
                SizedBox(height: 15),
                _botonEditar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _nombre(String nombre) {
    return TextFormField(
      initialValue: (nombre == '') ? null : nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.deepPurple),
        labelText: 'Nombre',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese el nombre del cliente',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => cliente.nombre = value.toString(),
    );
  }

  _identificacion(String identificacion) {
    return TextFormField(
      initialValue: (identificacion == '') ? null : identificacion,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.deepPurple),
        labelText: 'Identificación',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Escriba la cédula o RUC',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => cliente.identificacion = value.toString(),
    );
  }

  _domicilio(String domicilio) {
    return TextFormField(
      initialValue: (domicilio == '') ? null : domicilio,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline, color: Colors.deepPurple),
        labelText: 'Domicilio',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Escriba el lugar de residencia del cliente',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => cliente.domicilio = value.toString(),
    );
  }

  _email(String email) {
    return TextFormField(
        initialValue: (email == '') ? null : email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.person_outline, color: Colors.deepPurple),
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintText: 'Escriba correo electrónico',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
        ),
        onSaved: (value) => cliente.email = value.toString());
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
    final clienteProvider =
        Provider.of<ClienteProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion =
        await clienteProvider.editarCliente(cliente.identificacion, cliente);

    if (peticion['ok']) {
      AlertDialogOkEditClienteWidget.showAlertDialog(context);
    } else {
      AlertDialogFailEditClienteWidget.showAlertDialog(context);
    }
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
    final clienteProvider =
        Provider.of<ClienteProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await clienteProvider.crearClienteNuevo(cliente);

    if (peticion['ok']) {
      AlertDialogOkEditClienteWidget.showAlertDialog(context);
    } else {
      AlertDialogFailEditClienteWidget.showAlertDialog(context);
    }
  }
}
