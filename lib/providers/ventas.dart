import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:gestionafacil_v3/models/cliente.dart';
import 'package:gestionafacil_v3/models/producto.dart';

class VentasProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/ventas';
  final _token = "${dotenv.env['TOKEN']}";
  List<ProductoModel> listaTemporal = [];
  ClienteModel cliente = new ClienteModel(
    id: '-1',
    nombre: 'Consumidor Final',
    identificacion: '',
    domicilio: 'Tulcán',
    email: '',
  );
  String comentario = 'Ninguno';
  double ventaTotal = 0.0;

  get obtenerListaTemporal => listaTemporal;

  set agregarproducto(ProductoModel producto) {
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
    ventaTotal = sum;
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

  // Future<Map<String, dynamic>> realizarVenta() async {
  Future<Map<String, dynamic>> realizarVenta() async {
    Map<String, dynamic> venta = {
      "comprobante": "B000" + '2',
      "clienteId": "${cliente.id}",
      "fechaVenta": DateTime.now().toString(),
      "comentario": comentario,
      "totalVenta": ventaTotal,
      "listaProductos": _configurarListaProductos(listaTemporal)
    };
    print(jsonEncode(venta));
    final consulta = await http.post(
      Uri.parse(_url),
      body: jsonEncode(venta),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    print(consulta.body);
    if (consulta.statusCode != 200) {
      //error
      print('Error');
      return {"ok": false, "msg": 'Ha ocurrido un error'};
    } else {
      print('Exito');
      return {"ok": true, "msg": 'Ha salido todo muy bien'};
    }
  }
}
