import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  final String _url = "${dotenv.env['BASE_URL']}/api";

  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    final consulta = await http.post(
      Uri.parse(_url + '/login'),
      body: jsonEncode(data),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
    );
    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }

    final envioToken = {
      "token": dotenv.env['FIREBASE_TOKEN'].toString(),
    };

    final consulta2 = await http.post(
      Uri.parse(_url + '/notificaciones/agregarToken'),
      body: jsonEncode(envioToken),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
    );
    final Map<String, dynamic> decodedData2 = jsonDecode(consulta2.body);

    final consulta3 = await http.post(
      Uri.parse(_url + '/notificaciones/productosPorCaducarse'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": decodedData['token']
      },
    );
    final Map<String, dynamic> decodedData3 = jsonDecode(consulta3.body);
    final consulta4 = await http.post(
      Uri.parse(_url + '/notificaciones/bajoStock'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": decodedData['token']
      },
    );
    final Map<String, dynamic> decodedData4 = jsonDecode(consulta4.body);

    return <String, dynamic>{
      'ok': true,
      "usuario": decodedData['usuario'],
      "token": decodedData['token'],
      "firebase": decodedData2['msg'],
      "notificaciones": <String, String>{
        "Caducados": decodedData3['msg'],
        "Stock": decodedData4['msg']
      }
    };
  }
}
