import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/widgets/alerts_dialogs/compras.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/models/producto.dart';

class VentasProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/ventas';
  final _token = "${dotenv.env['TOKEN']}";
  List<ProductoModel> listaTemporal = [];
  ClienteModel cliente = new ClienteModel(
    id: '3',
    nombre: 'Consumidor Final',
    identificacion: '',
    domicilio: 'Tulcán',
    email: '',
  );
  String comentario = 'Ninguno';
  double ventaTotal = 0.0;
  String comprobante = '000';

  get obtenerListaTemporal => listaTemporal;

  set agregarproducto(ProductoModel producto) {
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
    this.ventaTotal = sum;
    return sum;
  }

  set agregarCliente(ClienteModel cliente) {
    this.cliente = cliente;
    notifyListeners();
  }

  ClienteModel mostrarCliente() => this.cliente;

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
        '${dotenv.env['BASE_URL']}/api/encabezadoVenta/consulta/ultimoEncabezado';
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
      return (resp['comprobante']['ultimoComprobante'] == null)
          ? 1
          : resp['comprobante']['ultimoComprobante'] + 1;
    }
  }

  // Future<Map<String, dynamic>> realizarVenta() async {
  Future<Map<String, dynamic>> realizarVenta() async {
    double saver = this.ventaTotal;
    Map<String, dynamic> venta = {
      "comprobante": await _obtenerUltimoComprobante(),
      "clienteId": "${cliente.id}",
      "fechaVenta": DateTime.now().toString(),
      "comentario": this.comentario,
      "totalVenta": saver,
      "listaProductos": _configurarListaProductos(listaTemporal)
    };

    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(venta),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    if (consulta.statusCode != 200) {
      //error

      return {"ok": false, "msg": 'Ha ocurrido un error'};
    } else {
      return {"ok": true, "msg": 'Ha salido todo muy bien'};
    }
  }

  Future<Map<String, dynamic>> realizarDonacion() async {
    Map<String, dynamic> venta = {
      "comprobante": await _obtenerUltimoComprobante(),
      "clienteId": "2",
      "fechaVenta": DateTime.now().toString(),
      "comentario": comentario,
      "totalVenta": obtenerSumaTotal(),
      "listaProductos": _configurarListaProductos(listaTemporal)
    };

    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(venta),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    if (consulta.statusCode != 200) {
      //error
      return {"ok": false, "msg": 'Ha ocurrido un error'};
    } else {
      return {"ok": true, "msg": 'Ha salido todo muy bien'};
    }
  }

  Future<Map<String, dynamic>> realizarConsumo() async {
    Map<String, dynamic> venta = {
      "comprobante": await _obtenerUltimoComprobante(),
      "clienteId": "1",
      "fechaVenta": DateTime.now().toString(),
      "comentario": comentario,
      "totalVenta": ventaTotal,
      "listaProductos": _configurarListaProductos(listaTemporal)
    };

    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(venta),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );

    if (consulta.statusCode != 200) {
      //error
      return {"ok": false, "msg": 'Ha ocurrido un error'};
    } else {
      return {"ok": true, "msg": 'Ha salido todo muy bien'};
    }
  }
}
