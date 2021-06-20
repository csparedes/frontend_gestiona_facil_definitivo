import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/models/kardex_salida.dart';
import 'package:http/http.dart' as http;

class KardexSalidaProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/kardex/salidas';
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<KardexSalidaModel>> mostrarExistencias() async {
    final consulta = await http.get(
      Uri.parse('$_url'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      print('Status Code: ${consulta.statusCode}');
      return [];
    }
    final List<KardexSalidaModel> listaKardex = [];
    decodedData.forEach((key, value) {
      if (key == 'kardex') {
        final List tmp = value;
        tmp.forEach((valor) {
          print(valor);

          listaKardex.add(
            new KardexSalidaModel(
              productoId: valor['Producto']['id'].toString(),
              fecha: DateTime.parse(valor['fecha'].toString()),
              cantidad: double.parse(valor['cantidad'].toString()),
              valorUnitario: double.parse(valor['valorUnitario'].toString()),
              productoString: valor['Producto']['nombre'],
            ),
          );
        });
      }
    });

    return listaKardex;
  }
}
