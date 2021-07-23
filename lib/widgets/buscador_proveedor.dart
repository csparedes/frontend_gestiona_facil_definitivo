import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:gestionafacil_v3/providers/proveedor.dart';
import 'package:provider/provider.dart';

class ProveedorSearchDelegate extends SearchDelegate {
  final comprasProvider;
  final String searchFieldLabel;
  @override
  ProveedorSearchDelegate(this.comprasProvider, this.searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(CupertinoIcons.clear),
        onPressed: () => this.query = '',
      ),
      IconButton(
        icon: Icon(CupertinoIcons.add),
        onPressed: () => Navigator.pushNamed(context, 'proveedorNuevo'),
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
    final proveedoresProvider = Provider.of<ProveedorProvider>(context);
    final columnas = ['Proveedor', 'Identificacion', ''];
    return FutureBuilder(
      future: proveedoresProvider.mostrarProveedorQueryNombre(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(context, snapshot.data, comprasProvider),
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final proveedoresProvider = Provider.of<ProveedorProvider>(context);
    final columnas = ['Proveedor', 'Identificacion', ''];
    return FutureBuilder(
      future: proveedoresProvider.mostrarProveedorQueryNombre(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(context, snapshot.data, comprasProvider),
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

  _getFilas(BuildContext context, List<ProveedorModel> proveedores,
          ComprasProvider comprasProvider) =>
      proveedores.map((ProveedorModel proveedor) {
        final cells = [
          proveedor.nombre,
          proveedor.identificacion,
          '${proveedor.id}_${proveedor.nombre}_${proveedor.identificacion}_${proveedor.domicilio}_${proveedor.email}',
        ];
        return DataRow(cells: _getCeldas(context, cells, comprasProvider));
      }).toList();

  _getCeldas(BuildContext context, List<dynamic> datos,
          ComprasProvider comprasProvider) =>
      datos
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
                              final id = split[0];
                              final nombre = split[1];
                              final identificacion = split[2];
                              final domicilio = split[3];
                              final email = split[4];
                              final temp = new ProveedorModel(
                                  id: id,
                                  nombre: nombre,
                                  identificacion: identificacion,
                                  domicilio: domicilio,
                                  email: email);
                              comprasProvider.agregarProveedor = temp;
                              this.close(context, null);
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
}
