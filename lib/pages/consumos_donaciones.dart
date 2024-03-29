import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/consumos_donaciones.dart';
import 'package:gestionafacil_v3/widgets/buscador_productos_venta.dart';
import 'package:provider/provider.dart';

class ConsumosDonacionesPage extends StatefulWidget {
  const ConsumosDonacionesPage({Key? key}) : super(key: key);

  @override
  _ConsumosDonacionesPageState createState() => _ConsumosDonacionesPageState();
}

class _ConsumosDonacionesPageState extends State<ConsumosDonacionesPage> {
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
        middle: Text('Donaciones o Consumos'),
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
          delegate: ProductosVentaSearchDelegate(
              ventasProvider, 'Nombre del Producto'),
        );
        setState(() {});
      },
      backgroundColor: Colors.deepPurple,
      // overlayColor: Colors.deepPurple,
      children: [
        SpeedDialChild(
          child: Icon(Icons.contactless_outlined),
          backgroundColor: Colors.green,
          label: 'Donar',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            ventasProvider.realizarDonacion();
            AlertDialogDonacionRealizada.showAlertDialog(context);
            ventasProvider.limpiarLista();
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.contactless_outlined),
          backgroundColor: Colors.blue,
          label: 'Consumir',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            ventasProvider.realizarConsumo();
            AlertDialogConsumoRealizado.showAlertDialog(context);
            ventasProvider.limpiarLista();
          },
        ),
      ],
    );
  }

  _fondoLista(BuildContext context, VentasProvider ventasProvider) {
    final size = MediaQuery.of(context).size;
    return Table(
      children: [
        TableRow(children: [
          _contenedorTable(context, size.height * 0.2,
              _clienteCajetin(context, ventasProvider))
        ]),
        TableRow(children: [
          _contenedorTable(context, size.height * 0.1,
              _camaraCajetin(context, ventasProvider))
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
        color: Colors.yellow[90],
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
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Table(
          children: [
            TableRow(
              children: [
                Text(
                  'Domicilio:',
                  style: TextStyle(fontSize: 20),
                ),
                Center(
                  heightFactor: 2,
                  child: Text('${clienteLista.domicilio}'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _camaraCajetin(BuildContext context, VentasProvider ventasProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            'Buscar productos',
            style: TextStyle(fontSize: 20),
          ),
        ),
        _escanear(ventasProvider)
      ],
    );
  }

  _escanear(VentasProvider ventasProvider) {
    return ElevatedButton.icon(
      onPressed: () => _scan(ventasProvider),
      icon: Icon(Icons.qr_code_2),
      label: Text('Escanear'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
      ),
    );
  }

  Future<void> _scan(VentasProvider ventasProvider) async {
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'Cancelar',
            'flash_on': 'Prender',
            'flash_off': 'Apagar',
          },
          android: AndroidOptions(
            aspectTolerance: 0,
            useAutoFocus: true,
          ),
        ),
      );
      setState(() {
        if (result.rawContent != '') {
          ventasProvider.agregarProductoPorCodigo(context, result.rawContent);
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
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
    final columns = ['Cant.', 'Nombre', 'Precio', 'Total', 'Acciones'];
    return DataTable(
      columns: _getColumnas(columns),
      rows: _getFilas(listaProductos, ventasProvider),
      columnSpacing: 20,
      dividerThickness: 0.5,
    );
  }

  _sumaLista(BuildContext context, VentasProvider ventasProvider) {
    return Center(
      child: Text(
        'Total del valor: ' +
            ventasProvider.obtenerSumaTotal().toStringAsFixed(2),
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

//Componentes

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
