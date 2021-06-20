import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/providers/cliente.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/clientes.dart';
import 'package:provider/provider.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Clientes'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'clienteNuevo');
          },
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaClientes(context),
    );
  }

  _listaClientes(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaClientes(context),
      ),
    );
  }

  _tablaClientes(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(context);
    final columnas = ['Nombre', 'Identificación', 'Domicilio', ''];

    return FutureBuilder(
      future: clienteProvider.mostrarClientes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 40,
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

  _getFilas(List<ClienteModel> clientes) =>
      clientes.map((ClienteModel cliente) {
        final cells = [
          cliente.nombre,
          cliente.identificacion,
          cliente.domicilio,
          '${cliente.id}_${cliente.nombre}_${cliente.identificacion}_${cliente.domicilio}_${cliente.email}'
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
                        onTap: () => Navigator.pushNamed(
                            context, 'clienteNuevo',
                            arguments: dato),
                        child: Icon(
                          Icons.create_outlined,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () =>
                            AlertDialogDeleteClienteWidget.showAlertDialog(
                                context, dato),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
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
