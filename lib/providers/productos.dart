import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:http/http.dart' as http;

class ProductosProvider extends ChangeNotifier {
  final _url = "${dotenv.env['BASE_URL']}/api/productos";
  final _token = "${dotenv.env['TOKEN']}";

  Future<List<ProductoModel>> mostrarTodosLosProductos() async {
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
    final List<ProductoModel> listaProductos = [];
    decodedData.forEach((key, value) {
      if (key == 'productos') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaProductos.add(
            new ProductoModel(
              nombre: valor['nombre'],
              categoriumId: valor['Categorium']['id'].toString(),
              categoriumString: valor['Categorium']['nombre'],
              codigo: valor['codigo'],
              precioVenta: valor['precioVenta'].toDouble(),
            ),
          );
        });
      }
    });

    return listaProductos;
  }

  Future<Map<String, dynamic>> crearProductoNuevo(
      ProductoModel producto) async {
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
      'producto': decodedData['producto']
    };
  }

  Future<Map<String, dynamic>> editarProducto(
      String codigo, ProductoModel producto) async {
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
    //enviar notificación
    final notificacionUrl =
        "${dotenv.env['BASE_URL']}/api/notificaciones/actualizacionProducto";
    final notificacion = await http.post(
      Uri.parse(notificacionUrl),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    final Map<String, dynamic> decodedNotificacion =
        json.decode(notificacion.body);
    return <String, dynamic>{
      'ok': true,
      'msg': decodedData['msg'],
      'producto': decodedData['producto'],
      'notificacion': decodedNotificacion['msg']
    };
  }

  Future<Map<String, dynamic>> borrarProducto(String codigo) async {
    final consulta = await http.delete(
      Uri.parse('$_url/$codigo'),
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

  Future<List<ProductoModel>> mostrarProductoQuery(String codigo) async {
    final consulta = await http.get(
      Uri.parse(_url + '/codigo/$codigo'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<ProductoModel> listaProductos = [];
    decodedData.forEach((key, value) {
      if (key == 'producto') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaProductos.add(
            new ProductoModel(
              nombre: valor['nombre'],
              categoriumId: valor['Categorium']['id'].toString(),
              categoriumString: valor['Categorium']['nombre'],
              codigo: valor['codigo'],
              precioVenta: valor['precioVenta'].toDouble(),
            ),
          );
        });
      }
    });

    return listaProductos;
  }

  Future<List<ProductoModel>> mostrarProductoNombreQuery(String nombre) async {
    final consulta = await http.get(
      Uri.parse(_url + '/nombre/$nombre'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<ProductoModel> listaProductos = [];
    decodedData.forEach((key, value) {
      if (key == 'productos') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaProductos.add(
            new ProductoModel(
              nombre: valor['nombre'],
              categoriumId: valor['Categorium']['id'].toString(),
              categoriumString: valor['Categorium']['nombre'],
              codigo: valor['codigo'],
              precioVenta: valor['precioVenta'].toDouble(),
            ),
          );
        });
      }
    });

    return listaProductos;
  }
}
