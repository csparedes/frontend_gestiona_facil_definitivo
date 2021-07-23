import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/proveedor.dart';

class ProveedorProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/proveedores';
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<ProveedorModel>> mostrarProveedores() async {
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
    final List<ProveedorModel> listaProveedores = [];
    decodedData.forEach((key, value) {
      if (key == 'proveedores') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaProveedores.add(
            new ProveedorModel(
              nombre: valor['nombre'],
              identificacion: valor['identificacion'],
              domicilio: valor['domicilio'],
              email: valor['email'],
            ),
          );
        });
      }
    });

    return listaProveedores;
  }

  Future<Map<String, dynamic>> crearProveedorNuevo(
      ProveedorModel proveedor) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(proveedor),
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

  Future<Map<String, dynamic>> editarProveedor(
      String identificacion, ProveedorModel proveedor) async {
    final consulta = await http.put(
      Uri.parse('$_url/$identificacion'),
      body: json.encode(proveedor),
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

  Future<Map<String, dynamic>> borrarProveedor(String identificacion) async {
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

  Future<List<ProveedorModel>> mostrarProveedorQueryNombre(
      String nombre) async {
    final consulta = await http.get(
      Uri.parse('$_url/$nombre'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<ProveedorModel> listaProveedores = [];
    decodedData.forEach((key, value) {
      if (key == 'proveedores') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaProveedores.add(new ProveedorModel(
              id: valor['id'].toString(),
              nombre: valor['nombre'],
              identificacion: valor['identificacion'],
              domicilio: valor['domicilio'],
              email: valor['email']));
        });
      }
    });

    return listaProveedores;
  }
}
