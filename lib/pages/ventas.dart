import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/models/invoice_customer.dart';
import 'package:gestionafacil_v3/models/invoice_pdf.dart';
import 'package:gestionafacil_v3/models/invoice_supplier.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/pdf_api_provider.dart';
import 'package:gestionafacil_v3/providers/pdf_provider.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/ventas.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/ventas_precio.dart';
import 'package:gestionafacil_v3/widgets/buscador_cliente.dart';
import 'package:gestionafacil_v3/widgets/buscador_productos_venta.dart';
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
        iconTheme: IconThemeData(color: Colors.white),
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
            child: Icon(
              Icons.contactless_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
            label: 'Vender',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final res = await ventasProvider.realizarVenta();
              if (res['ok']) {
                AlertDialogVentaRealizada.showAlertDialog(context);
                ventasProvider.limpiarLista();
              } else {
                AlertDialogVentaFallida.showAlertDialog(context, res['razon']);
              }
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.clear_all,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            label: 'Limpiar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => ventasProvider.limpiarLista(),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.person_add_alt_1_outlined,
              color: Colors.white,
            ),
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
            child: Icon(
              Icons.wrap_text,
              color: Colors.white,
            ),
            backgroundColor: Colors.orange,
            label: 'Agregar Comentario',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(context, 'ventasComentario'),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            label: 'Generar PDF',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final date = DateTime.now();
              final dueDate = DateTime.now().add(Duration(days: 15));
              final invoice = Invoice(
                supplier: Supplier(
                    name: 'Víveres Stalin',
                    address: 'Tulcán - Ecuador',
                    paymentInfo: ''),
                customer: Customer(
                    name: ventasProvider.mostrarCliente().nombre,
                    address: ventasProvider.mostrarCliente().domicilio,
                    cedula: ventasProvider.mostrarCliente().identificacion),
                info: InvoiceInfo(
                    description: ventasProvider.mostrarComentario,
                    number:
                        await ventasProvider.obtenerUltimoComprobanteString(),
                    date: date,
                    dueDate: dueDate),
                items: ventasProvider.productoInvoicePdf(),
              );

              final pdfFile = await PdfInvoiceApi.generate(invoice);
              PdfApi.openFile(pdfFile);
            },
          ),
        ]);
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
          _contenedorTable(context, size.height * 0.10,
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
                  'Cliente:',
                  style: TextStyle(fontSize: 20),
                ),
                Center(
                  heightFactor: 2,
                  child: Text(
                    '${clienteLista.nombre}',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  'Cédula:',
                  style: TextStyle(fontSize: 20),
                ),
                Center(
                  heightFactor: 2,
                  child: Text('${clienteLista.identificacion}'),
                )
              ],
            ),
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
            'name': 'lol',
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
      columnSpacing: 18,
      dividerThickness: 0.5,
    );
  }

  _sumaLista(BuildContext context, VentasProvider ventasProvider) {
    return Center(
      child: Text(
        'Total a Cobrar: ' +
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
          producto.cantidadAux.toStringAsFixed(0) + '#${producto.codigo}',
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
              ? Container(
                  child: (dato.toString().contains('#'))
                      ? GestureDetector(
                          onLongPress: () {
                            final str = dato.toString().split('#')[1];
                            AlertDialogEditarCantidadVenta.showAlertDialog(
                                context, ventasProvider, str);
                          },
                          child: Text(dato.toString().split('#')[0]),
                        )
                      : Text(dato.toString()),
                )
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
