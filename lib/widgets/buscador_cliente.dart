import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:gestionafacil_v3/providers/ventas.dart';
import 'package:provider/provider.dart';

class ClientesSearchDelegate extends SearchDelegate {
  final ventasProvider;
  final String searchFieldLabel;
  @override
  ClientesSearchDelegate(this.ventasProvider, this.searchFieldLabel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(CupertinoIcons.clear),
        onPressed: () => this.query = '',
      ),
      IconButton(
        icon: Icon(CupertinoIcons.add),
        onPressed: () => Navigator.pushNamed(context, 'clienteNuevo'),
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
    final clientesProvider = Provider.of<ClienteProvider>(context);

    final columnas = ['Cliente', 'Identificacion', ''];
    return FutureBuilder(
      future: clientesProvider.mostrarClientesQueryIdentificacion(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(context, snapshot.data, ventasProvider),
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

  _getFilas(BuildContext context, List<ClienteModel> clientes,
          VentasProvider ventasProvider) =>
      clientes.map((ClienteModel cliente) {
        final cells = [
          cliente.nombre,
          cliente.identificacion,
          '${cliente.id}_${cliente.nombre}_${cliente.identificacion}_${cliente.domicilio}_${cliente.email}',
        ];
        return DataRow(cells: _getCeldas(context, cells, ventasProvider));
      }).toList();

  _getCeldas(BuildContext context, List<dynamic> datos,
          VentasProvider ventasProvider) =>
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
                              final temp = new ClienteModel(
                                  id: id,
                                  nombre: nombre,
                                  identificacion: identificacion,
                                  domicilio: domicilio,
                                  email: email);
                              ventasProvider.agregarCliente = temp;
                              this.close(context, null);
                              // print(ventasProvider.imprimirLista);
                              //Agregar Productos a la lista inicial
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
    final clientesProvider = Provider.of<ClienteProvider>(context);
    final ventasProvider = Provider.of<VentasProvider>(context);
    final columnas = ['Nombre', 'Precio', ''];
    return FutureBuilder(
      future: clientesProvider.mostrarClientesQueryIdentificacion(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 60,
            columns: _getColumnas(columnas),
            rows: _getFilas(context, snapshot.data, ventasProvider),
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
