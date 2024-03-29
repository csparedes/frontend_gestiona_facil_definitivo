import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:provider/provider.dart';

import 'package:gestionafacil_v3/providers/productos.dart';

class ProductosCompraSearchDelegate extends SearchDelegate {
  final comprasProvider;
  final String searchFieldLabel;
  ProductosCompraSearchDelegate(this.comprasProvider, this.searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(CupertinoIcons.clear),
        onPressed: () => this.query = '',
      ),
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
    final productosProvider = Provider.of<ProductosProvider>(context);

    final columnas = ['Nombre', 'Precio', ''];
    return FutureBuilder(
      future: productosProvider.mostrarProductoNombreQuery(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data, comprasProvider),
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

  _getFilas(List<ProductoModel> productos, ComprasProvider comprasProvider) =>
      productos.map((ProductoModel producto) {
        final cells = [
          producto.nombre,
          producto.precioVenta.toString(),
          '${producto.id}_${producto.codigo}_${producto.nombre}_${producto.precioVenta}_${producto.categoriumId}',
        ];
        return DataRow(cells: _getCeldas(cells, comprasProvider));
      }).toList();

  _getCeldas(List<dynamic> datos, ComprasProvider comprasProvider) => datos
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
                          final nombre = split[2];
                          final categoriumId = split[4];
                          final codigo = split[1];
                          final precioVenta = double.parse(split[3]);
                          final temp = new ProductoModel(
                            nombre: nombre,
                            categoriumId: categoriumId,
                            codigo: codigo,
                            precioVenta: precioVenta,
                            cantidadAux: 1,
                          );

                          comprasProvider.agregarProducto = temp;
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
    final productosProvider = Provider.of<ProductosProvider>(context);
    final comprasProvider = Provider.of<ComprasProvider>(context);
    final columnas = ['Nombre', 'Precio', ''];
    return FutureBuilder(
      future: productosProvider.mostrarProductoNombreQuery(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(snapshot.data, comprasProvider),
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
