import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/percha.dart';
import 'package:gestionafacil_v3/providers/perchar.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/perchas.dart';
import 'package:provider/provider.dart';

class PercharPage extends StatefulWidget {
  const PercharPage({Key? key}) : super(key: key);

  @override
  _PercharPageState createState() => _PercharPageState();
}

class _PercharPageState extends State<PercharPage> {
  List<PerchaModel> listaPerchas = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Perchar Productos'),
        trailing: GestureDetector(
          onTap: () {},
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaPerchas(context),
    );
  }

  _listaPerchas(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaPerchas(context),
      ),
    );
  }

  _tablaPerchas(BuildContext context) {
    final productoProvider = Provider.of<PercharProvider>(context);
    final columnas = ['Caja', 'Artículo', 'Acciones'];

    return FutureBuilder(
      future: productoProvider.mostrarEnlacesPerchas(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          listaPerchas = snapshot.data;
          return DataTable(
            columnSpacing: 30,
            columns: _getColumnas(columnas),
            rows: _getFilas(listaPerchas),
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
            label: Text(
              columna,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ))
      .toList();

  _getFilas(List<PerchaModel> perchas) => perchas.map((PerchaModel percha) {
        final cells = [
          percha.cajaId,
          percha.articuloId,
          '${percha.id}-${percha.cajaId}-${percha.articuloId}'
        ];
        return DataRow(cells: _getCeldas(cells));
      }).toList();

  _getCeldas(List<dynamic> datos) => datos
      .map(
        (dato) => DataCell(
          (!dato.toString().contains('-'))
              ? Text('$dato')
              : Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, 'percharNueva',
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
                        onTap: () => AlertDialogDeletePercha.showAlertDialog(
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
