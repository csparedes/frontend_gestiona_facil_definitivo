import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/kardex_existencia.dart';

class KardexExistenciasProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/kardex/existencias';
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<KardexExistenciaModel>> mostrarExistencias() async {
    final consulta = await http.get(
      Uri.parse('$_url'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<KardexExistenciaModel> listaKardex = [];
    decodedData.forEach((key, value) {
      if (key == 'kardex') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaKardex.add(
            new KardexExistenciaModel(
              productoId: valor['Producto']['id'].toString(),
              fechaCaducidad: DateTime.parse(valor['fechaCaducidad']),
              cantidad: double.parse(valor['cantidad'].toString()),
              valorIngreso: double.parse(valor['valorIngreso'].toString()),
              productoString: valor['Producto']['nombre'],
            ),
          );
        });
      }
    });

    return listaKardex;
  }

  Future<List<KardexExistenciaModel>> mostrarExistenciasPorQuery(
      String query) async {
    final consulta = await http.get(
      Uri.parse('$_url/producto/$query'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<KardexExistenciaModel> listaKardex = [];
    decodedData.forEach((key, val) {
      KardexExistenciaModel kardexAux = new KardexExistenciaModel(
          productoId: '',
          fechaCaducidad: DateTime.now(),
          cantidad: 0.0,
          valorIngreso: 0.0);

      if (key == 'listaKardex') {
        final List tmp = val;
        tmp.forEach((value) {
          kardexAux.productoId = (value['Producto']['id']).toString();
          kardexAux.productoCategoria = value['Producto']['categoriumId'];
          kardexAux.productoPrecio =
              double.parse(value['Producto']['precioVenta'].toString());
          kardexAux.productoCodigo = value['Producto']['codigo'];
          kardexAux.productoString = value['Producto']['nombre'];
          kardexAux.fechaCaducidad = DateTime.parse(value['fechaCaducidad']);
          kardexAux.cantidad = double.parse(value['cantidad'].toString());
          kardexAux.valorIngreso =
              double.parse(value['valorIngreso'].toString());
        });
        listaKardex.add(kardexAux);
      }
    });

    return listaKardex;
  }

  Future<Map<String, dynamic>> editarProducto(
      String codigo, KardexExistenciaModel producto) async {
    final consulta = await http.put(
      Uri.parse('$_url/$codigo'),
      body: json.encode(producto),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    notifyListeners();

    final Map<String, dynamic> decodedData = json.decode(consulta.body);

    if (consulta.statusCode != 200) {
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
      'producto': decodedData['producto']
    };
  }
}
