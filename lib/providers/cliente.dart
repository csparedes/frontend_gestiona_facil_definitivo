import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/cliente.dart';

class ClienteProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/clientes';
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<ClienteModel>> mostrarClientes() async {
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
    final List<ClienteModel> listaClientes = [];
    decodedData.forEach((key, value) {
      if (key == 'clientes') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaClientes.add(new ClienteModel(
              nombre: valor['nombre'],
              identificacion: valor['identificacion'],
              domicilio: valor['domicilio'],
              email: valor['email']));
        });
      }
    });

    return listaClientes;
  }

  Future<Map<String, dynamic>> crearClienteNuevo(ClienteModel cliente) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(cliente),
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
      'cliente': decodedData['cliente']
    };
  }

  Future<Map<String, dynamic>> editarCliente(
      String identificacion, ClienteModel cliente) async {
    final consulta = await http.put(
      Uri.parse('$_url/$identificacion'),
      body: json.encode(cliente),
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
      'cliente': decodedData['cliente']
    };
  }

  Future<Map<String, dynamic>> borrarCliente(String identificacion) async {
    final consulta = await http.delete(
      Uri.parse('$_url/$identificacion'),
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

  Future<List<ClienteModel>> mostrarClientesQueryIdentificacion(
      String identificacion) async {
    final consulta = await http.get(
      Uri.parse('$_url/$identificacion'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<ClienteModel> listaClientes = [];
    decodedData.forEach((key, value) {
      if (key == 'clientes') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaClientes.add(new ClienteModel(
              id: valor['id'].toString(),
              nombre: valor['nombre'],
              identificacion: valor['identificacion'],
              domicilio: valor['domicilio'],
              email: valor['email']));
        });
      }
    });

    return listaClientes;
  }
}
