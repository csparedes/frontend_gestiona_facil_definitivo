import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/ventas.dart';
import 'package:gestionafacil_v3/widgets/buscador_cliente.dart';
import 'package:gestionafacil_v3/widgets/buscador_productos.dart';
import 'package:provider/provider.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({Key? key}) : super(key: key);

  @override
  _VentasPageState createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  List<ProductoModel> listaProductos = [];
  ClienteModel clienteLista = new ClienteModel(
    nombre: '',
    identificacion: '',
    domicilio: '',
    email: '',
  );

  @override
  Widget build(BuildContext context) {
    final ventasProvider = Provider.of<VentasProvider>(context);
    listaProductos = ventasProvider.mostrarListaTemporal();
    clienteLista = ventasProvider.mostrarCliente();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Nueva Venta'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _fondoLista(context, ventasProvider),
          ],
        ),
      ),
      floatingActionButton: _botonSpeedDial(ventasProvider),
    );
  }

  SpeedDial _botonSpeedDial(VentasProvider ventasProvider) {
    return SpeedDial(
        icon: Icons.add,
        buttonSize: 56,
        visible: true,
        curve: Curves.bounceIn,
        onPress: () {
          showSearch(
            context: context,
            delegate: ProductosSearchDelegate(ventasProvider),
          );
          setState(() {});
        },
        backgroundColor: Colors.deepPurple,
        // overlayColor: Colors.deepPurple,
        children: [
          SpeedDialChild(
            child: Icon(Icons.contactless_outlined),
            backgroundColor: Colors.green,
            label: 'Vender',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              ventasProvider.realizarVenta();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.clear_all),
            backgroundColor: Colors.red,
            label: 'Limpiar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => ventasProvider.limpiarLista(),
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add_alt_1_outlined),
            backgroundColor: Colors.blue,
            label: 'Agregar Cliente',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              showSearch(
                context: context,
                delegate: ClientesSearchDelegate(
                    ventasProvider, 'Número de cédula...'),
              );
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.wrap_text),
            backgroundColor: Colors.orange,
            label: 'Agregar Comentario',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(context, 'ventasComentario'),
          ),
        ]);
  }

  _fondoLista(BuildContext context, VentasProvider ventasProvider) {
    final size = MediaQuery.of(context).size;
    return Table(
      children: [
        TableRow(children: [
          _contenedorTable(context, size.height * 0.3,
              _clienteCajetin(context, ventasProvider))
        ]),
        TableRow(children: [
          _contenedorTable(context, size.height * 0.45,
              _listaProductos(context, ventasProvider))
        ]),
        TableRow(children: [
          _contenedorTable(
              context, size.height * 0.1, _sumaLista(context, ventasProvider))
        ]),
      ],
    );
  }

  Container _contenedorTable(BuildContext context, double high, Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      height: high,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.yellow,
        border: Border.all(
          color: Colors.deepPurple,
          style: BorderStyle.solid,
          width: 5,
        ),
      ),
      child: child,
    );
  }

  _clienteCajetin(BuildContext context, VentasProvider ventasProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child:
                Text('ClienteID: ${clienteLista.id} - ${clienteLista.nombre}'),
          ),
          //   _nombre(clienteLista.nombre),
          //   _identificacion(clienteLista.identificacion),
          //   _domicilio(clienteLista.domicilio),
          //   _email(clienteLista.email),
        ],
      ),
    );
  }

  _listaProductos(BuildContext context, VentasProvider ventasProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tablaProductosTemporales(context, ventasProvider),
        ],
      ),
    );
  }

  _tablaProductosTemporales(
      BuildContext context, VentasProvider ventasProvider) {
    final columns = ['Cant.', 'Nombre', 'Precio', 'Total', ''];
    return DataTable(
      columns: _getColumnas(columns),
      rows: _getFilas(listaProductos, ventasProvider),
      columnSpacing: 20,
      dividerThickness: 0.5,
    );
  }

  _sumaLista(BuildContext context, VentasProvider ventasProvider) {
    return Center(
      child: Text('Total a Cobrar: ' +
          ventasProvider.obtenerSumaTotal().toStringAsFixed(2)),
    );
  }

//Componentes
  TextFormField _nombre(String nombre) {
    return TextFormField(
      initialValue: (nombre == '') ? '' : nombre,
      // initialValue: 'Cliente',
      textCapitalization: TextCapitalization.sentences,
      // textInputAction: TextInputAction.continueAction,
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
      // onSaved: (value) => cliente.nombre = value.toString(),
    );
  }

  TextFormField _identificacion(String identificacion) {
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
      // onSaved: (value) => cliente.identificacion = value.toString(),
    );
  }

  TextFormField _domicilio(String domicilio) {
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
      // onSaved: (value) => cliente.domicilio = value.toString(),
    );
  }

  TextFormField _email(String email) {
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
    );
    // onSaved: (value) => cliente.email = value.toString());
  }

  _getColumnas(List<String> columnas) => columnas
      .map((String columna) => DataColumn(
            label: Text(columna),
          ))
      .toList();

  _getFilas(List<ProductoModel> productos, VentasProvider ventasProvider) =>
      productos.map((ProductoModel producto) {
        // final i = 0;
        final cells = [
          producto.cantidadAux.toStringAsFixed(0),
          producto.nombre,
          producto.precioVenta.toStringAsFixed(2),
          producto.totalAux.toStringAsFixed(2),
          '_${producto.codigo}'
          //acciones
        ];
        return DataRow(cells: _getCeldas(cells, ventasProvider));
      }).toList();

  _getCeldas(List<dynamic> datos, VentasProvider ventasProvider) => datos
      .map(
        (dato) => DataCell(
          (!dato.toString().contains('_'))
              ? Text('$dato')
              : Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final split = dato.toString().split('_')[1];
                          ventasProvider.disminuirCantidad(split);
                        },
                        child: Icon(
                          CupertinoIcons.minus,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final split = dato.toString().split('_')[1];
                          ventasProvider.aumentarCantidad(split);
                        },
                        child: Icon(
                          CupertinoIcons.add,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final split = dato.toString().split('_')[1];
                          ventasProvider.eliminarProducto(split);
                        },
                        child: Icon(
                          CupertinoIcons.delete,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ),
        ),
      )
      .toList();
}
