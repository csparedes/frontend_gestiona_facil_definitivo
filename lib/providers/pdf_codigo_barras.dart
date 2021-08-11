import 'dart:io';
import 'package:gestionafacil_v3/providers/pdf_api_provider.dart';
import 'package:pdf/widgets.dart';

class PdfCodigoBarras {
  static Future<File> generate(String data) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                Container(
                  height: 300,
                  width: 600,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: data,
                    ),
                  ),
                )
              ]),
    );

    return PdfApi.saveDocument(name: 'codigo_barras.pdf', pdf: pdf);
  }
}
