import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/categoria.dart';
import 'package:gestionafacil_v3/providers/categoria.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/categorias.dart';
import 'package:provider/provider.dart';

class CategoriaNuevaPage extends StatefulWidget {
  const CategoriaNuevaPage({Key? key}) : super(key: key);

  @override
  _CategoriaNuevaPageState createState() => _CategoriaNuevaPageState();
}

class _CategoriaNuevaPageState extends State<CategoriaNuevaPage> {
  final formKey = GlobalKey<FormState>();
  CategoriaModel categoria = new CategoriaModel(nombre: '', descripcion: '');
  @override
  Widget build(BuildContext context) {
    final stringCategoria = ModalRoute.of(context)!.settings.arguments;
    if (stringCategoria != null) {
      final split = stringCategoria.toString().split('_');
      categoria.id = split[0];
      categoria.nombre = split[1];
      categoria.descripcion = split[2];
      return _scaffoldEditarCategoria(context, categoria);
    }
    return _scaffoldCrearCategoria(context);
  }

  Scaffold _scaffoldCrearCategoria(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Crear Categoria'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(categoria.nombre),
                SizedBox(height: 5),
                _descripcion(categoria.descripcion),
                SizedBox(height: 5),
                _botonCrear(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold _scaffoldEditarCategoria(
      BuildContext context, CategoriaModel categoria) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Editar Categoría'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(categoria.nombre),
                SizedBox(height: 5),
                _descripcion(categoria.descripcion),
                SizedBox(height: 5),
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
        icon: Icon(Icons.category_outlined, color: Colors.deepPurple),
        labelText: 'Categoria',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese el nombre de la categoria',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => categoria.nombre = value.toString(),
    );
  }

  _descripcion(String descripcion) {
    return TextFormField(
      initialValue: (descripcion == '') ? null : descripcion,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        icon: Icon(Icons.description_outlined, color: Colors.deepPurple),
        labelText: 'Descripción',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Escriba la descripción',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => categoria.descripcion = value.toString(),
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
    final categoriaProvider =
        Provider.of<CategoriaProvider>(context, listen: false);
    final peticion =
        await categoriaProvider.editarCategoria(categoria.id, categoria);

    if (peticion['ok']) {
      AlertDialogOkEditarCategoria.showAlertDialog(context);
    } else {
      AlertDialogFailEditarCategoria.showAlertDialog(context);
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
    final categoriaProvider =
        Provider.of<CategoriaProvider>(context, listen: false);
    final peticion = await categoriaProvider.crearCategoriaNueva(categoria);
    if (peticion['ok']) {
      AlertDialogOkCrearCategoria.showAlertDialog(context);
    } else {
      AlertDialogFailCrearCategoria.showAlertDialog(context);
    }
  }
}
