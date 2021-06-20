import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/kardex_ingresos.dart';
import 'package:gestionafacil_v3/providers/kardex_ingresos.dart';
import 'package:provider/provider.dart';

class IngresosPage extends StatefulWidget {
  const IngresosPage({Key? key}) : super(key: key);

  @override
  _IngresosPageState createState() => _IngresosPageState();
}

class _IngresosPageState extends State<IngresosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Kardex Ingresos'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaIngresos(context),
    );
  }

  _listaIngresos(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaIngresos(context),
      ),
    );
  }

  _tablaIngresos(BuildContext context) {
    final kardexProvider = Provider.of<KardexIngresosProvider>(context);
    final columnas = ['Producto', 'Ingreso', 'Cantidad', 'Precio'];

    return FutureBuilder(
      future: kardexProvider.mostrarIngresos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 40,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data),
          );
        }
        return Center(
            child: CupertinoActivityIndicator(
          radius: 20,
        ));
      },
    );
  }

  _getColumnas(List<String> columnas) => columnas
      .map((String columna) => DataColumn(
            label: Text(columna),
          ))
      .toList();

  _getFilas(List<KardexIngresoModel> existencias) =>
      existencias.map((KardexIngresoModel kardex) {
        final cells = [
          kardex.productoString,
          kardex.fecha.toString(),
          kardex.cantidad.toString(),
          kardex.valorUnitario.toString(),
        ];
        return DataRow(cells: _getCeldas(cells));
      }).toList();

  _getCeldas(List<dynamic> datos) => datos
      .map(
        (dato) => DataCell(
          Text('$dato'),
        ),
      )
      .toList();
}
