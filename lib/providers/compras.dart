import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/compras.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';

class ComprasProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/compras';
  final _token = "${dotenv.env['TOKEN']}";
  List<ProductoModel> listaTemporal = [];

  ProveedorModel proveedor = new ProveedorModel(
      nombre: 'Sin Proveedor',
      identificacion: '000000000',
      domicilio: 'Tulcán',
      email: '');

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

  agregarProductoPorCodigo(BuildContext context, String codigo) async {
    final _urlProductos =
        '${dotenv.env['BASE_URL']}/api/productos/codigo/$codigo';
    final consultaProducto = await http.get(
      Uri.parse(_urlProductos),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    final decodedProducto = jsonDecode(consultaProducto.body);
    if (decodedProducto['msg'] == 'No hay producto') {
      AlertDialogProductoNoEncontrado.showAlertDialog(context);
      return;
    }
    final producto = new ProductoModel(
        nombre: decodedProducto['producto']['nombre'],
        categoriumId: decodedProducto['producto']['categoriumId'],
        codigo: decodedProducto['producto']['codigo'],
        precioVenta: double.parse(
            decodedProducto['producto']['precioVenta'].toString()));
    final temp = listaTemporal
        .indexWhere((element) => element.codigo == producto.codigo);
    if (temp != -1) {
      //ok, aumentar cantidad
      listaTemporal[temp].aumentarCantidad();
    } else {
      producto.cantidadAux = 1;
      producto.totalAux = producto.cantidadAux * producto.precioVenta;
      listaTemporal.add(producto);
    }
    notifyListeners();
  }

  List<ProductoModel> mostrarListaTemporal() => listaTemporal;

  limpiarLista() {
    listaTemporal.clear();
    proveedor = new ProveedorModel(
        nombre: 'Sin Proveedor',
        identificacion: '000000000',
        domicilio: 'Tulcán',
        email: '');
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

  void modificarCantidad(String codigo, cantidad) {
    final temp =
        listaTemporal.indexWhere((element) => element.codigo == codigo);
    if (temp != -1) {
      listaTemporal[temp].modificarCantidad(cantidad);
    }
    notifyListeners();
  }

  void modificarPrecio(String codigo, precio) {
    final temp =
        listaTemporal.indexWhere((element) => element.codigo == codigo);

    if (temp != -1) {
      listaTemporal[temp].modificarPrecio(precio);
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

  void asignarFechaCaducidad(String dato, String fecha) {
    final aux = dato.split('_')[1];
    final temp = listaTemporal.indexWhere((element) => element.codigo == aux);
    if (temp != -1) {
      listaTemporal[temp].fechaCaducidadAux = fecha;
    }
    notifyListeners();
  }

  double obtenerSumaTotal() {
    double sum = 0.0;
    listaTemporal.forEach((producto) {
      sum += producto.totalAux;
    });
    this.compraTotal = sum;
    return sum;
  }

  set agregarProveedor(ProveedorModel proveedor) {
    this.proveedor = proveedor;
    notifyListeners();
  }

  ProveedorModel mostrarProveedro() => this.proveedor;

  set agregarComentario(String comment) {
    this.comentario = comment;
    notifyListeners();
  }

  get mostrarComentario => comentario;

  List _configurarListaProductos(List<ProductoModel> lista) {
    List aux = [];

    lista.forEach((producto) {
      final temp = {
        'codigo': producto.codigo,
        'cantidad': producto.cantidadAux,
        'valorUnitario': producto.precioVenta,
        'fechaCaducidad': producto.fechaCaducidadAux,
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
    double saver = this.compraTotal;
    Map<String, dynamic> compra = {
      "comprobante": await _obtenerUltimoComprobante(),
      "proveedoreId": "${proveedor.id}",
      "fechaCompra": DateTime.now().toString(),
      "comentario": comentario,
      "totalCompra": saver,
      "listaProductos": _configurarListaProductos(listaTemporal),
    };
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

  Future<Map<String, dynamic>> realizarPedido() async {
    double saver = this.compraTotal;
    Map<String, dynamic> compra = {
      "comprobante": await _obtenerUltimoComprobante(),
      "proveedoreId": "${proveedor.id}",
      "fechaCompra": DateTime.now().toString(),
      "comentario": comentario,
      "totalCompra": saver,
      "listaProductos": _configurarListaProductos(listaTemporal),
    };
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
