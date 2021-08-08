import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenerarCodigoPage extends StatefulWidget {
  const GenerarCodigoPage({Key? key}) : super(key: key);

  @override
  _GenerarCodigoPageState createState() => _GenerarCodigoPageState();
}

class _GenerarCodigoPageState extends State<GenerarCodigoPage> {
  @override
  Widget build(BuildContext context) {
    final stringProducto = ModalRoute.of(context)!.settings.arguments;
    print(':::Codigo' + stringProducto.toString());
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
          SizedBox(
            height: 20,
          ),
          _mostrarCodigo(stringProducto.toString()),
          SizedBox(
            height: 20,
          ),
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
