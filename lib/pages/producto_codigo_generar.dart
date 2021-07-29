import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenerarCodigoPage extends StatelessWidget {
  const GenerarCodigoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringProducto = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.deepPurple,
        ),
        middle: Text('Generar Código Nuevo'),
        border: Border(bottom: BorderSide(width: 1)),
      ),
      body: Column(
        children: [
          _mostrarCodigo(stringProducto.toString()),
        ],
      ),
    );
  }

  _mostrarCodigo(String data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: BarcodeWidget(
        barcode: Barcode.code128(),
        data: data,
      ),
    );
  }
}
