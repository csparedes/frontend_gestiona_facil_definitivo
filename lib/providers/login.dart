import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  final String _url = "${dotenv.env['BASE_URL']}/api/login";

  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(data),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
    );
    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      print("${decodedData['msg']}");
      return <String, dynamic>{
        'ok': false,
        'msg': decodedData['msg'],
      };
    }
    print("$decodedData");
    return <String, dynamic>{
      'ok': true,
      "usuario": decodedData['usuario'],
      "token": decodedData['token'],
    };
  }
}
