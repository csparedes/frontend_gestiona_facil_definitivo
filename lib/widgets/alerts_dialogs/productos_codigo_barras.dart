import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/providers/pdf_api_provider.dart';
import 'package:gestionafacil_v3/providers/pdf_codigo_barras.dart';

class AlertDialogProductoCodigoBarras {
  static showAlertDialog(
      BuildContext context, String data, ProductoModel producto) {
    // Create button
    Widget okButton = CupertinoButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        producto.codigo = data;
        Navigator.of(context).pop();
      },
    );

    Widget printButton = CupertinoButton(
      child: Text('Imprimir',
          style: TextStyle(
            color: Colors.deepPurple,
          )),
      onPressed: () async {
        final pdfFile = await PdfCodigoBarras.generate(data);
        PdfApi.openFile(pdfFile);
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Código Barras"),
      content: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: BarcodeWidget(
            barcode: Barcode.code128(),
            data: data,
          ),
        ),
      ),
      actions: [
        okButton,
        printButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
