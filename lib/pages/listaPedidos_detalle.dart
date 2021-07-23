import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/models/detalle_pedido.dart';
import 'package:gestionafacil_v3/providers/pedidos.dart';
import 'package:provider/provider.dart';

class DetallePedidoPage extends StatelessWidget {
  const DetallePedidoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idComprobante = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Pedido #' + idComprobante),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaAticulos(context, idComprobante),
      floatingActionButton: _botonSpeedDial(context),
    );
  }

  SpeedDial _botonSpeedDial(BuildContext context) {
    return SpeedDial(
      buttonSize: 56,
      visible: true,
      curve: Curves.bounceIn,
      icon: Icons.add,
      backgroundColor: Colors.deepPurple,
      children: [
        SpeedDialChild(
          child: Icon(Icons.check_outlined),
          backgroundColor: Colors.green,
          label: 'Aceptar Pedido',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.clear_outlined),
          backgroundColor: Colors.red,
          label: 'Rechazar Pedido',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _listaAticulos(BuildContext context, String idComprobante) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaArticulos(context, idComprobante),
      ),
    );
  }

  _tablaArticulos(BuildContext context, String idComprobante) {
    final pedidosProvider = Provider.of<PedidosProvider>(context);
    final columnas = ['Producto', 'Cantidad', 'Precio'];

    return FutureBuilder(
      future: pedidosProvider.mostrarArticulosPedido(idComprobante),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 100,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data),
          );
        }
        return Container(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        );
      },
    );
  }

  _getColumnas(List<String> columnas) => columnas
      .map((String columna) => DataColumn(
            label: Text(columna),
          ))
      .toList();

  _getFilas(List<DetallePedidoModel> articulos) =>
      articulos.map((DetallePedidoModel articulo) {
        final cells = [
          articulo.productoString,
          articulo.cantidad.toStringAsFixed(2),
          articulo.valorUnitario.toStringAsFixed(2),
        ];
        return DataRow(cells: _getCeldas(cells));
      }).toList();

  _getCeldas(List<dynamic> datos) => datos
      .map(
        (dato) => DataCell(Text('$dato')),
      )
      .toList();
}
