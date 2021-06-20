import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/productos.dart';
import 'package:provider/provider.dart';

Future<void> startBarcodeScanStream() async {
  FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#7c43bd', 'Cancelar', true, ScanMode.BARCODE)!
      .listen((barcode) => print(barcode));
}

String _scanBarcode = '';
mostrarBarcodeScan() {
  return Container(
    alignment: Alignment.center,
    child: Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => startBarcodeScanStream(),
            child: Text('Escanear Producto')),
        Text('Scan result : $_scanBarcode\n', style: TextStyle(fontSize: 20))
      ],
    ),
  );
}

agregarProductosManualmente(BuildContext context) {
  return Container(
    child: SingleChildScrollView(
      child: Table(
        children: [
          TableRow(children: [
            _buscador(context),
          ]),
          TableRow(children: [
            _listado(context),
          ]),
        ],
      ),
    ),
  );
}

_buscador(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    color: Colors.blue,
    height: size.height * 0.1,
    child: Text('Buscador'),
  );
}

_listado(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    color: Colors.red,
    height: size.height * 1.6,
    child: Text('Listado'),
  );
}
