import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/productos.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/productos.dart';
import 'package:provider/provider.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({Key? key}) : super(key: key);

  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  List<ProductoModel> listaProductos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Productos'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'productoNuevo');
          },
          child: Icon(
            CupertinoIcons.add,
            color: Colors.deepPurple,
          ),
        ),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: _listaProductos(context),
    );
  }

  _listaProductos(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _tablaProductos(context),
      ),
    );
  }

  _tablaProductos(BuildContext context) {
    final productoProvider = Provider.of<ProductosProvider>(context);
    final columnas = ['Producto', 'Precio', 'Categoria', ''];

    return FutureBuilder(
      future: productoProvider.mostrarTodosLosProductos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          listaProductos = snapshot.data;
          return DataTable(
            columnSpacing: 40,
            columns: _getColumnas(columnas),
            rows: _getFilas(listaProductos),
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

  _getFilas(List<ProductoModel> productos) =>
      productos.map((ProductoModel producto) {
        final cells = [
          producto.nombre,
          producto.precioVenta.toString(),
          producto.categoriumString,
          '${producto.id}-${producto.nombre}-${producto.precioVenta}-${producto.categoriumId}-${producto.codigo}'
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
                            context, 'productoNuevo',
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
                            AlertDialogDeleteProductoWidget.showAlertDialog(
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
