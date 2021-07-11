import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gestionafacil_v3/providers/compras.dart';
import 'package:provider/provider.dart';

class ComprasComentarioPage extends StatelessWidget {
  const ComprasComentarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comprasProvider = Provider.of<ComprasProvider>(context);
    String comentario = '';
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Comentario de Compra'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: TextField(
                onChanged: (value) => comentario = value,
                decoration: InputDecoration(
                  labelText: 'Comentario',
                  hintText: 'Ingrese su comentario aquí',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.check,
        backgroundColor: Colors.deepPurple,
        buttonSize: 56,
        visible: true,
        onPress: () {
          comprasProvider.agregarComentario = comentario;
          print(comprasProvider.mostrarComentario);
          Navigator.pop(context);
        },
        children: [
          SpeedDialChild(
            child: Icon(Icons.clear),
            backgroundColor: Colors.red,
            onTap: () => Navigator.pop(context),
            label: 'Cancelar',
          )
        ],
      ),
    );
  }
}
