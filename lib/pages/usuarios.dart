import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gestionafacil_v3/models/usuario.dart';
import 'package:gestionafacil_v3/providers/usuarios.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/usuarios.dart';
import 'package:provider/provider.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  int? sortIndex;
  bool isAscending = false;
  List<UsuarioModel> usuarios = [];

  @override
  Widget build(BuildContext context) {
    // final usuarioProvider = Provider.of<UsuariosProvider>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Usuarios'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'usuarioNuevo');
          },
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaUsuarios(context),
    );
  }

  _listaUsuarios(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: _tablaUsuarios(),
      ),
    );
  }

  _tablaUsuarios() {
    final usuarioProvider = Provider.of<UsuariosProvider>(context);
    final columnas = ['Nombre', 'Email', 'Rol', ''];
    return FutureBuilder(
      future: usuarioProvider.mostrarUsuarios(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          this.usuarios = snapshot.data;
          return DataTable(
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
            ),
            columnSpacing: 8,
            sortAscending: isAscending,
            sortColumnIndex: sortIndex,
            columns: _getColumnas(columnas),
            rows: _getFilas(usuarios),
            headingRowHeight: 30,
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

  List<DataColumn> _getColumnas(List<String> columnas) => columnas
      .map(
        (String columna) => DataColumn(
          label: Text(columna),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> _getFilas(List<UsuarioModel> usuarios) =>
      usuarios.map((UsuarioModel usuario) {
        final cells = [
          usuario.nombre,
          usuario.email,
          usuario.roleId,
          '${usuario.id}-${usuario.nombre}-${usuario.email}-${usuario.roleId}'
        ];
        return DataRow(
          cells: _getCeldas(cells),
        );
      }).toList();

  List<DataCell> _getCeldas(List<dynamic> datos) => datos
      .map(
        (dato) => DataCell(
          (!dato.toString().contains('-'))
              ? Text('$dato')
              : Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, 'usuarioNuevo',
                            arguments: dato),
                        // AlertDialogEditUsuarioWidget.showAlertDialog(
                        //     context, dato),
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
                        onTap: () => AlertDialogDeleteUsuario.showAlertDialog(
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

  void onSort(int indexColumna, bool ascending) {
    if (indexColumna == 0) {
      usuarios.sort((user1, user2) =>
          compararString(ascending, user1.nombre, user2.nombre));
    }

    setState(() {
      this.sortIndex = indexColumna;
      this.isAscending = ascending;
    });
  }

  int compararString(bool ascending, String value1, String value2) {
    if (ascending) {
      return value1.compareTo(value2);
    }
    return value2.compareTo(value1);
  }
}
