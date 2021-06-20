import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/kardex_salida.dart';
import 'package:gestionafacil_v3/providers/kardex_salida.dart';
import 'package:provider/provider.dart';

class SalidasPage extends StatefulWidget {
  const SalidasPage({Key? key}) : super(key: key);

  @override
  _SalidasPageState createState() => _SalidasPageState();
}

class _SalidasPageState extends State<SalidasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Kardex Salidas'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaSalidas(context),
    );
  }

  _listaSalidas(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaSalidas(context),
      ),
    );
  }

  _tablaSalidas(BuildContext context) {
    final kardexProvider = Provider.of<KardexSalidaProvider>(context);
    final columnas = ['Producto', 'Fecha', 'Cantidad', 'Precio'];

    return FutureBuilder(
      future: kardexProvider.mostrarExistencias(),
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

  _getFilas(List<KardexSalidaModel> existencias) =>
      existencias.map((KardexSalidaModel kardex) {
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
