import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/kardex_existencia.dart';
import 'package:gestionafacil_v3/providers/kardex_existencias.dart';
import 'package:provider/provider.dart';

class ExistenciasPage extends StatefulWidget {
  const ExistenciasPage({Key? key}) : super(key: key);

  @override
  _ExistenciasPageState createState() => _ExistenciasPageState();
}

class _ExistenciasPageState extends State<ExistenciasPage> {
  List<KardexExistenciaModel> listaExistencias = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Existencias'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaExistenciasW(context),
    );
  }

  _listaExistenciasW(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaExistencias(context),
      ),
    );
  }

  _tablaExistencias(BuildContext context) {
    final kardexProvider = Provider.of<KardexExistenciasProvider>(context);
    final columnas = ['Producto', 'Expiración', 'Cantidad'];

    return FutureBuilder(
      future: kardexProvider.mostrarExistencias(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          listaExistencias = snapshot.data;
          return DataTable(
            columnSpacing: 40,
            columns: _getColumnas(columnas),
            rows: _getFilas(listaExistencias),
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

  _getFilas(List<KardexExistenciaModel> existencias) =>
      existencias.map((KardexExistenciaModel kardex) {
        final cells = [
          kardex.productoString,
          kardex.fechaCaducidad.toString(),
          kardex.cantidad.toString()
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
