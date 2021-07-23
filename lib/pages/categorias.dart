import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/categoria.dart';
import 'package:gestionafacil_v3/providers/categoria.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/categorias.dart';
import 'package:provider/provider.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({Key? key}) : super(key: key);

  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Categorías'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'categoriaNueva');
          },
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaCategorias(context),
    );
  }

  _listaCategorias(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaCategorias(context),
      ),
    );
  }

  _tablaCategorias(BuildContext context) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    final columnas = ['Nombre', 'Descripción', 'Acciones'];

    return FutureBuilder(
      future: categoriaProvider.mostrarCategorias(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columnSpacing: 40,
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

  _getFilas(List<CategoriaModel> categorias) =>
      categorias.map((CategoriaModel categoria) {
        final cells = [
          categoria.nombre,
          categoria.descripcion,
          '${categoria.id}_${categoria.nombre}_${categoria.descripcion}'
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
                            context, 'categoriaNueva',
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
                        onTap: () => AlertDialogDeleteCategoria.showAlertDialog(
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
