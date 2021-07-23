import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';
import 'package:gestionafacil_v3/providers/proveedor.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/clientes.dart';
import 'package:provider/provider.dart';

class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({Key? key}) : super(key: key);

  @override
  _ProveedoresPageState createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Proveedores'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'proveedorNuevo');
          },
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaProveedores(context),
    );
  }

  _listaProveedores(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaProveedores(context),
      ),
    );
  }

  _tablaProveedores(BuildContext context) {
    final proveedorProvider = Provider.of<ProveedorProvider>(context);
    final columnas = ['Nombre', 'Identificación', 'Domicilio', ''];

    return FutureBuilder(
      future: proveedorProvider.mostrarProveedores(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 20,
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

  _getFilas(List<ProveedorModel> proveedores) =>
      proveedores.map((ProveedorModel proveedor) {
        final cells = [
          proveedor.nombre,
          proveedor.identificacion,
          proveedor.domicilio,
          '${proveedor.id}_${proveedor.nombre}_${proveedor.identificacion}_${proveedor.domicilio}_${proveedor.email}'
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
                            context, 'proveedorNuevo',
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
