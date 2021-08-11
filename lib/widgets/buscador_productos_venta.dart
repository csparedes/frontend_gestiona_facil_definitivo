import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/kardex_existencia.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/kardex_existencias.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:provider/provider.dart';

class ProductosVentaSearchDelegate extends SearchDelegate {
  final ventasProvider;
  final String searchFieldLabel;
  ProductosVentaSearchDelegate(this.ventasProvider, this.searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(CupertinoIcons.clear), onPressed: () => this.query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.arrow_left),
      onPressed: () => this.close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final kardexProvider = Provider.of<KardexExistenciasProvider>(context);

    final columnas = ['Nombre', 'Precio', ''];
    return FutureBuilder(
      future: kardexProvider.mostrarExistenciasPorQuery(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data, ventasProvider),
            dividerThickness: 0.5,
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        }
      },
    );
  }

  _getColumnas(List<String> columnas) => columnas
      .map((String columna) => DataColumn(
            label: Text(columna),
          ))
      .toList();

  _getFilas(
          List<KardexExistenciaModel> kardexs, VentasProvider ventasProvider) =>
      kardexs.map((KardexExistenciaModel kardex) {
        final cells = [
          kardex.productoString,
          kardex.productoPrecio.toString(),
          '${kardex.id}_${kardex.productoId}_${kardex.productoString}_${kardex.productoPrecio}_${kardex.productoCategoria}_${kardex.productoCodigo}',
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
                          final split = dato.split('_');
                          final id = split[1];
                          final nombre = split[2];
                          final categoria = split[4];
                          final codigo = split[5];
                          final precio = double.parse(split[3]);
                          final temp = new ProductoModel(
                            id: id,
                            nombre: nombre,
                            categoriumId: categoria,
                            precioVenta: precio,
                            codigo: codigo,
                          );
                          ventasProvider.agregarproducto = temp;
                        },
                        child: Icon(
                          CupertinoIcons.add,
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final kardexProvider = Provider.of<KardexExistenciasProvider>(context);

    final columnas = ['Nombre', 'Precio', ''];
    return FutureBuilder(
      future: kardexProvider.mostrarExistenciasPorQuery(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data, ventasProvider),
            dividerThickness: 0.5,
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        }
      },
    );
  }
}
