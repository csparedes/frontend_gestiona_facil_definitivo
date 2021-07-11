import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';

class ComprasProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/compras';
  final _token = "${dotenv.env['TOKEN']}";
  List<ProductoModel> listaTemporal = [];

  ProveedorModel proveedor = new ProveedorModel(
    id: '-1',
    nombre: '',
    identificacion: '',
    domicilio: 'Tulcán',
    email: '',
  );

  String comentario = 'Ninguna Novedad';
  double compraTotal = 0.0;

  get obtenerListaTemporal => listaTemporal;

  set agregarProducto(ProductoModel producto) {
    final temp = listaTemporal
        .indexWhere((element) => element.codigo == producto.codigo);
    if (temp != -1) {
      //ok, aumentar cantidad
      listaTemporal[temp].aumentarCantidad();
    } else {
      listaTemporal.add(producto);
    }

    notifyListeners();
  }

  List<ProductoModel> mostrarListaTemporal() => listaTemporal;

  limpiarLista() {
    listaTemporal.clear();
    notifyListeners();
  }

  get imprimirLista {
    String salida = '';
    listaTemporal.forEach((producto) {
      salida += producto.nombre.toString() + '--';
    });
    return salida;
  }

  void aumentarCantidad(String codigo) {
    final temp =
        listaTemporal.indexWhere((element) => element.codigo == codigo);

    if (temp != -1) {
      listaTemporal[temp].aumentarCantidad();
    }

    notifyListeners();
  }

  void disminuirCantidad(String codigo) {
    final temp =
        listaTemporal.indexWhere((element) => element.codigo == codigo);

    if (temp != -1) {
      if (listaTemporal[temp].cantidadAux <= 1) {
        listaTemporal.removeAt(temp);
      } else {
        listaTemporal[temp].disminuirCantidad();
      }
    }

    notifyListeners();
  }

  void eliminarProducto(String codigo) {
    final temp =
        listaTemporal.indexWhere((element) => element.codigo == codigo);

    if (temp != -1) {
      listaTemporal.removeAt(temp);
    }

    notifyListeners();
  }

  double obtenerSumaTotal() {
    double sum = 0.0;
    listaTemporal.forEach((producto) {
      sum += producto.totalAux;
    });
    compraTotal = sum;
    return sum;
  }

  set agregarProveedor(ProveedorModel proveedor) {
    this.proveedor = proveedor;
    notifyListeners();
  }

  ProveedorModel mostrarProveedro() => this.proveedor;

  set agregarComentario(String comment) {
    comentario = comment;
    notifyListeners();
  }

  get mostrarComentario => comentario;

  List _configurarListaProductos(List<ProductoModel> lista) {
    List aux = [];

    lista.forEach((producto) {
      final temp = {
        'codigo': producto.codigo,
        'cantidad': producto.cantidadAux,
        'valorUnitario': producto.precioVenta
      };
      aux.add(temp);
    });

    return aux;
  }

  Future<int> _obtenerUltimoComprobante() async {
    final _urlAux =
        '${dotenv.env['BASE_URL']}/api/encabezadoCompra/consulta/ultimoEncabezado';
    final consulta = await http.get(
      Uri.parse(_urlAux),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    if (consulta.statusCode != 200) {
      return -1;
    } else {
      final resp = jsonDecode(consulta.body);
      return resp['comprobante']['ultimoComprobante'] + 1;
    }
  }

  Future<Map<String, dynamic>> realizarCompra() async {
    Map<String, dynamic> compra = {
      "comprobante": await _obtenerUltimoComprobante(),
      "proveedoreId": "${proveedor.id}",
      "fechaCompra": DateTime.now().toString(),
      "comentario": comentario,
      "totalCompra": compraTotal,
      "listaProductos": _configurarListaProductos(listaTemporal),
    };
    print('$compra');
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(compra),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    if (consulta.statusCode != 200) {
      //error
      return {"ok": false, "msg": "Ha ocurrido un error"};
    } else {
      return {"ok": true, "msg": "Ha salido muy bien"};
    }
  }
}
