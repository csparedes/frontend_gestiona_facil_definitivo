import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/encabezadoPedido.dart';
import 'package:gestionafacil_v3/providers/pedidos.dart';
import 'package:provider/provider.dart';

class ListaPedidosPage extends StatefulWidget {
  const ListaPedidosPage({Key? key}) : super(key: key);

  @override
  _ListaPedidosPageState createState() => _ListaPedidosPageState();
}

class _ListaPedidosPageState extends State<ListaPedidosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Lista de Pedidos'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaPedidos(context),
    );
  }

  _listaPedidos(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaPedidos(context),
      ),
    );
  }

  _tablaPedidos(BuildContext context) {
    final pedidosProvider = Provider.of<PedidosProvider>(context);
    final columnas = ['Proveedor', 'Total', 'Acciones'];

    return FutureBuilder(
      future: pedidosProvider.mostrarEncabezadosPedidos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 80,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
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

  _getFilas(List<EncabezadoPedidoModel> encabezados) =>
      encabezados.map((EncabezadoPedidoModel encabezado) {
        final cells = [
          encabezado.proveedoreString,
          encabezado.totalPedido.toStringAsFixed(2),
          '${encabezado.id}_${encabezado.comprobante}'
        ];
        return DataRow(cells: _getCeldas(cells));
      }).toList();

  _getCeldas(List<dynamic> datos) => datos
      .map(
        (dato) => DataCell(
          (!dato.toString().contains('_'))
              ? Text('$dato')
              : Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final split = dato.toString().split('_');
                          Navigator.pushNamed(context, 'detallePedido',
                              arguments: split[1]);
                        },
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      )
      .toList();
}
