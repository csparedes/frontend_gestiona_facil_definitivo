import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/models/categoria.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/categorias';
  final _token = '${dotenv.env['TOKEN']}';

  Future<List<Map<String, dynamic>>> cargarCategoriasWidget() async {
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
    final List<Map<String, dynamic>> listaC = [];
    decodedData.forEach((key, value) {
      if (key == 'categorias') {
        final List tmp = value;
        tmp.forEach((element) {
          listaC.add(<String, dynamic>{
            'value': element['id'],
            'label': element['nombre'],
          });
        });
      }
    });
    return listaC;
  }

  Future<List<CategoriaModel>> mostrarCategorias() async {
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
    final List<CategoriaModel> listaC = [];
    decodedData.forEach((key, value) {
      if (key == 'categorias') {
        final List tmp = value;
        tmp.forEach((element) {
          listaC.add(CategoriaModel(
            id: element['id'].toString(),
            nombre: element['nombre'],
            descripcion: element['descripcion'],
          ));
        });
      }
    });
    return listaC;
  }

  Future<Map<String, dynamic>> crearCategoriaNueva(
      CategoriaModel categoria) async {
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(categoria),
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

  Future<Map<String, dynamic>> editarCategoria(
      String identificacion, CategoriaModel categoria) async {
    final consulta = await http.put(
      Uri.parse('$_url/$identificacion'),
      body: json.encode(categoria),
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

  Future<Map<String, dynamic>> borrarCategoria(String identificacion) async {
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
}
