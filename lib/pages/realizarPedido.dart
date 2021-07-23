import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/compras_precio.dart';
import 'package:gestionafacil_v3/widgets/buscador_productos_compra.dart';
import 'package:gestionafacil_v3/widgets/buscador_proveedor.dart';
import 'package:provider/provider.dart';

class RealizarPedidoPage extends StatefulWidget {
  const RealizarPedidoPage({Key? key}) : super(key: key);

  @override
  _RealizarPedidoPageState createState() => _RealizarPedidoPageState();
}

class _RealizarPedidoPageState extends State<RealizarPedidoPage> {
  List<ProductoModel> listaProductos = [];
  DateTime selectedDate = DateTime.now();
  ProveedorModel proveedorLista = new ProveedorModel(
    nombre: '',
    identificacion: '',
    domicilio: '',
    email: '',
  );
  @override
  Widget build(BuildContext context) {
    final comprasProvider = Provider.of<ComprasProvider>(context);
    listaProductos = comprasProvider.mostrarListaTemporal();
    proveedorLista = comprasProvider.mostrarProveedro();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Realizar Pedido'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _fondoLista(context, comprasProvider),
          ],
        ),
      ),
      floatingActionButton: _botonSpeedDial(comprasProvider),
    );
  }

  SpeedDial _botonSpeedDial(ComprasProvider comprasProvider) {
    return SpeedDial(
        icon: Icons.add,
        buttonSize: 56,
        visible: true,
        curve: Curves.bounceIn,
        onPress: () {
          showSearch(
            context: context,
            delegate: ProductosCompraSearchDelegate(comprasProvider),
          );
          setState(() {});
        },
        backgroundColor: Colors.deepPurple,
        // overlayColor: Colors.deepPurple,
        children: [
          SpeedDialChild(
            child: Icon(Icons.contactless_outlined),
            backgroundColor: Colors.green,
            label: 'Realizar Pedido',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              comprasProvider.realizarPedido();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.clear_all),
            backgroundColor: Colors.red,
            label: 'Limpiar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => comprasProvider.limpiarLista(),
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add_alt_1_outlined),
            backgroundColor: Colors.blue,
            label: 'Agregar Proveedor',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              showSearch(
                context: context,
                delegate: ProveedorSearchDelegate(
                    comprasProvider, 'Nombre del Proveedor...'),
              );
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.wrap_text),
            backgroundColor: Colors.orange,
            label: 'Agregar Comentario',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(context, 'comprasComentario'),
          ),
        ]);
  }

  _fondoLista(BuildContext context, ComprasProvider comprasProvider) {
    final size = MediaQuery.of(context).size;
    return Table(
      children: [
        TableRow(children: [
          _contenedorTable(context, size.height * 0.05,
              _proveedorCajetin(context, comprasProvider))
        ]),
        TableRow(children: [
          _contenedorTable(context, size.height * 0.7,
              _listaProductos(context, comprasProvider))
        ]),
        TableRow(children: [
          _contenedorTable(
              context, size.height * 0.1, _sumaLista(context, comprasProvider))
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
        color: Colors.blue[90],
        border: Border.all(
          color: Colors.deepPurple,
          style: BorderStyle.solid,
          width: 5,
        ),
      ),
      child: child,
    );
  }

  _proveedorCajetin(BuildContext context, ComprasProvider comprasProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text(
                'ProveedorID: ${proveedorLista.id} - ${proveedorLista.nombre}'),
          ),
        ],
      ),
    );
  }

  _listaProductos(BuildContext context, ComprasProvider comprasProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tablaProductosTemporales(context, comprasProvider),
        ],
      ),
    );
  }

  _tablaProductosTemporales(
      BuildContext context, ComprasProvider comprasProvider) {
    final columns = ['Cant.', 'Nombre', 'Precio', 'Total', 'Acciones'];
    return DataTable(
      columns: _getColumnas(columns),
      rows: _getFilas(listaProductos, comprasProvider),
      columnSpacing: 8,
      dividerThickness: 0.5,
    );
  }

  _sumaLista(BuildContext context, ComprasProvider comprasProvider) {
    return Center(
      child: Text('Total a Pagar: ' +
          comprasProvider.obtenerSumaTotal().toStringAsFixed(2)),
    );
  }

  _getColumnas(List<String> columnas) => columnas
      .map((String columna) => DataColumn(
            label: Text(columna),
          ))
      .toList();

  _getFilas(List<ProductoModel> productos, ComprasProvider comprasProvider) =>
      productos.map((ProductoModel producto) {
        // final i = 0;
        final cells = [
          producto.cantidadAux.toStringAsFixed(1) + '#${producto.codigo}',
          producto.nombre,
          producto.precioVenta.toStringAsFixed(2) + '%${producto.codigo}',
          producto.totalAux.toStringAsFixed(2),
          '_${producto.codigo}'
          //acciones
        ];
        return DataRow(cells: _getCeldas(cells, comprasProvider));
      }).toList();

  _getCeldas(List<dynamic> datos, ComprasProvider comprasProvider) => datos
      .map(
        (dato) => DataCell(
          (!dato.toString().contains('_'))
              ? Container(
                  child: (dato.toString().contains('%'))
                      ? GestureDetector(
                          onLongPress: () {
                            final str = dato.toString().split('%')[1];
                            AlertDialogEditarPrecioCompra.showAlertDialog(
                                context, comprasProvider, str);
                          },
                          child: Text(dato.toString().split('%')[0]),
                        )
                      : (dato.toString().contains('#'))
                          ? GestureDetector(
                              onLongPress: () {
                                final str = dato.toString().split('#')[1];
                                AlertDialogEditarCantidadCompra.showAlertDialog(
                                    context, comprasProvider, str);
                              },
                              child: Text(dato.toString().split('#')[0]),
                            )
                          : Text(dato.toString()),
                )
              : Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _selectDate(context, comprasProvider, dato),
                        child: Icon(
                          CupertinoIcons.calendar,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final split = dato.toString().split('_')[1];
                          comprasProvider.disminuirCantidad(split);
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
                          comprasProvider.aumentarCantidad(split);
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
                          comprasProvider.eliminarProducto(split);
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

  _selectDate(BuildContext context, ComprasProvider comprasProvider,
      String dato) async {
    final picked = await showRoundedDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
      borderRadius: 16,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        final fechaCaducidad = picked.toString().split(' ')[0];
        comprasProvider.asignarFechaCaducidad(dato, fechaCaducidad);
      });
  }
}
