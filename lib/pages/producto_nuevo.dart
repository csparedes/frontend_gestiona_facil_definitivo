import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/categoria.dart';
import 'package:gestionafacil_v3/providers/productos.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/productos.dart';
import 'package:provider/provider.dart';

class ProductoNuevoPage extends StatefulWidget {
  const ProductoNuevoPage({Key? key}) : super(key: key);

  @override
  _ProductoNuevoPageState createState() => _ProductoNuevoPageState();
}

class _ProductoNuevoPageState extends State<ProductoNuevoPage> {
  final formKey = GlobalKey<FormState>();
  final codigoController = new TextEditingController(text: 'Sin código');
  ProductoModel producto = new ProductoModel(
    id: '',
    nombre: '',
    categoriumId: '',
    codigo: '',
    precioVenta: 0.0,
  );
  @override
  Widget build(BuildContext context) {
    final stringProducto = ModalRoute.of(context)!.settings.arguments;

    if (stringProducto != null) {
      final split = stringProducto.toString().split('-');
      producto.id = split[0];
      producto.nombre = split[1];
      producto.precioVenta = double.parse(split[2]);
      producto.categoriumId = split[3];
      producto.codigo = split[4];
      return _scaffoldEditarProducto(context, producto);
    }
    return _scaffoldCrearProducto(context, producto);
  }

  _scaffoldEditarProducto(BuildContext context, ProductoModel producto) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Editar Producto'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(producto.nombre),
                SizedBox(height: 5),
                _categoria(context, producto.categoriumId),
                SizedBox(height: 5),
                _precioVenta(producto.precioVenta),
                SizedBox(height: 15),
                _codigo(producto.codigo),
                SizedBox(height: 5),
                _escanear(),
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
        icon: Icon(Icons.rice_bowl_outlined, color: Colors.deepPurple),
        labelText: 'Nombre',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Ingrese el nombre del producto',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => producto.nombre = value.toString(),
      onChanged: (value) => producto.nombre = value.toString(),
    );
  }

  _categoria(BuildContext context, String categoria) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    return FutureBuilder(
        future: categoriaProvider.cargarCategoriasWidget(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }
          final List<Map<String, dynamic>> _items =
              snapshot.data as List<Map<String, dynamic>>;
          return SelectFormField(
            type: SelectFormFieldType.dropdown,
            initialValue: (categoria != '') ? categoria : null,
            icon: Icon(Icons.category),
            labelText: 'Categoría',
            hintText: 'Seleccione la categoría',
            onSaved: (value) => producto.categoriumId = value.toString(),
            onChanged: (value) => producto.categoriumId = value.toString(),
            items: _items,
          );
        });
  }

  _codigo(String codigo) {
    if (codigo != '') {
      codigoController.text = codigo;
    }
    return TextFormField(
      controller: codigoController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.horizontal_split_outlined, color: Colors.deepPurple),
        labelText: 'Codigo',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Escriba el codigo',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      enabled: false,
      onSaved: (value) => producto.codigo = value.toString(),
    );
  }

  _generar() {
    final codigoGenerado = '${producto.categoriumId} ${producto.nombre}';
    return ElevatedButton.icon(
      onPressed: () => (producto.nombre == '' || producto.categoriumId == '')
          ? AlertDialogDatosGenerarCodigoProducto.showAlertDialog(context)
          : Navigator.pushNamed(context, 'generarCodigo',
              arguments: codigoGenerado),
      icon: Icon(Icons.upload_file_outlined),
      label: Text('Generar Código'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
      ),
    );
  }

  _escanear() {
    return ElevatedButton.icon(
      onPressed: () => _scan(),
      icon: Icon(Icons.qr_code_2),
      label: Text('Escanear'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
      ),
    );
  }

  _precioVenta(double precio) {
    return TextFormField(
      initialValue: (precio == 0.0) ? null : precio.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.price_check_outlined, color: Colors.deepPurple),
        labelText: 'Precio',
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintText: 'Escriba el Precio',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      onSaved: (value) => producto.precioVenta = double.parse(value!),
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
    final productosProvider =
        Provider.of<ProductosProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion =
        await productosProvider.editarProducto(producto.codigo, producto);

    if (peticion['ok']) {
      AlertDialogOkEditProductoWidget.showAlertDialog(context);
    } else {
      AlertDialogFailEditProductoWidget.showAlertDialog(
          context, peticion['msg']);
    }
  }

  _scaffoldCrearProducto(BuildContext context, ProductoModel producto) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Crear Producto'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nombre(producto.nombre),
                SizedBox(height: 5),
                _categoria(context, producto.categoriumId),
                SizedBox(height: 5),
                _precioVenta(producto.precioVenta),
                SizedBox(height: 15),
                _codigo(producto.codigo),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _generar(),
                    _escanear(),
                  ],
                ),
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
    final productosProvider =
        Provider.of<ProductosProvider>(context, listen: false);
    // usuariosProvider.crearNuevoUsuario = usuario;

    final peticion = await productosProvider.crearProductoNuevo(producto);

    if (peticion['ok']) {
      AlertDialogOkCrearProducto.showAlertDialog(context);
    } else {
      AlertDialogFailCrearProducto.showAlertDialog(context, peticion['msg']);
    }
  }

  Future<void> _scan() async {
    print('entro al scan');
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'Cancelar',
            'flash_on': 'Prender',
            'flash_off': 'Apagar',
            'name': 'lol',
          },
          android: AndroidOptions(
            aspectTolerance: 0,
            useAutoFocus: true,
          ),
        ),
      );
      setState(() {
        print('lol ' + result.rawContent);
        codigoController.text = result.rawContent;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
