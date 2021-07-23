import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gestionafacil_v3/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuariosProvider extends ChangeNotifier {
  final _url = "${dotenv.env['BASE_URL']}/api/usuarios";
  final _token = "${dotenv.env['TOKEN']}";

  Future<Map<String, dynamic>> crearUsuario(UsuarioModel usuario) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(usuario),
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
        'msg': decodedData['errors']['errors'][0]['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
      'usuario': decodedData['usuario']
    };
  }

  Future<List<UsuarioModel>> mostrarUsuarios() async {
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
    final List<UsuarioModel> listaUsuarios = [];
    decodedData.forEach((key, value) {
      if (key == 'usuarios') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaUsuarios.add(
            new UsuarioModel(
                id: valor['id'].toString(),
                nombre: valor['nombre'],
                roleId: valor['Role']['rol'],
                email: valor['email']),
          );
        });
      }
    });

    return listaUsuarios;
  }

  Future<Map<String, dynamic>> editarUsuario(
      String id, UsuarioModel usuario) async {
    final consulta = await http.put(
      Uri.parse('$_url/$id'),
      body: jsonEncode(usuario),
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
        'msg': decodedData['errors']['errors'][0]['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
      'usuario': decodedData['actualUsuario']
    };
  }

  Future<Map<String, dynamic>> borrarUsuario(String id) async {
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
        'msg': decodedData['errors']['errors'][0]['msg'],
      };
    }

    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
    };
  }
}
