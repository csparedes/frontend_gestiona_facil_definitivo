import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';
import 'package:gestionafacil_v3/providers/proveedor.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/clientes.dart';
import 'package:provider/provider.dart';

class ProveedorNuevoPage extends StatefulWidget {
  const ProveedorNuevoPage({Key? key}) : super(key: key);

  @override
  _ProveedorNuevoPageState createState() => _ProveedorNuevoPageState();
}

class _ProveedorNuevoPageState extends State<ProveedorNuevoPage> {
  final formKey = GlobalKey<FormState>();
  ProveedorModel proveedor = new ProveedorModel(
      nombre: '', identificacion: '', domicilio: '', email: '');
  @override
  Widget build(BuildContext context) {
    final stringProveedor = ModalRoute.of(context)!.settings.arguments;
    if (stringProveedor != null) {
      final split = stringProveedor.toString().split('_');
      // '${cliente.id}_${cliente.nombre}_${cliente.identificacion}_${cliente.domicilio}_${cliente.email}'
      proveedor.id = split[0];
      proveedor.nombre = split[1];
      proveedor.identificacion = split[2];
      proveedor.domicilio = split[3];
      proveedor.email = split[4];
      return _scaffoldEditarCliente(context, proveedor);
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
                _nombre(proveedor.nombre),
                SizedBox(height: 5),
                _identificacion(proveedor.identificacion),
                SizedBox(height: 5),
                _domicilio(proveedor.domicilio),
                SizedBox(height: 5),
                _email(proveedor.email),
                SizedBox(height: 15),
                _botonCrear(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold _scaffoldEditarCliente(
      BuildContext context, ProveedorModel proveedor) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Editar Proveedor'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(proveedor.nombre),
                SizedBox(height: 5),
                _identificacion(proveedor.identificacion),
                SizedBox(height: 5),
                _domicilio(proveedor.domicilio),
                SizedBox(height: 5),
                _email(proveedor.email),
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
        hintText: 'Ingrese el nombre del Proveedor',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => proveedor.nombre = value.toString(),
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
      onSaved: (value) => proveedor.identificacion = value.toString(),
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
        hintText: 'Escriba el lugar de residencia del proveedor',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => proveedor.domicilio = value.toString(),
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
        onSaved: (value) => proveedor.email = value.toString());
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
    final proveedorProvider =
        Provider.of<ProveedorProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await proveedorProvider.editarProveedor(
        proveedor.identificacion, proveedor);

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
    final proveedorProvider =
        Provider.of<ProveedorProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await proveedorProvider.crearProveedorNuevo(proveedor);

    if (peticion['ok']) {
      AlertDialogOkEditClienteWidget.showAlertDialog(context);
    } else {
      AlertDialogFailEditClienteWidget.showAlertDialog(context);
    }
  }
}
