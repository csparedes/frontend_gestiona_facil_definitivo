import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/models/percha.dart';
import 'package:http/http.dart' as http;

class PercharProvider extends ChangeNotifier {
  final _url = "${dotenv.env['BASE_URL']}/api/perchas";
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<PerchaModel>> mostrarEnlacesPerchas() async {
    final consulta = await http.get(
      Uri.parse(_url),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);
    if (consulta.statusCode != 200) {
      return [];
    }

    final List<PerchaModel> listaPerchas = [];
    decodedData.forEach((key, value) {
      if (key == 'perchas') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaPerchas.add(
            new PerchaModel(
              cajaId: valor['cajaId'],
              articuloId: valor['articuloId'],
            ),
          );
        });
      }
    });

    return listaPerchas;
  }

  Future<Map<String, dynamic>> crearPerchaNueava(PerchaModel producto) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(producto),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    notifyListeners();

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
    };
  }

  Future<Map<String, dynamic>> editarPerchaNueava(
      String id, PerchaModel producto) async {
    final consulta = await http.post(
      Uri.parse('$_url/$id'),
      body: jsonEncode(producto),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    notifyListeners();

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
    };
  }

  Future<Map<String, dynamic>> borrarPercha(String id) async {
    final consulta = await http.delete(
      Uri.parse('$_url/$id'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    notifyListeners();

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
    };
  }
}
