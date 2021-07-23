import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gestionafacil_v3/models/detalle_pedido.dart';
import 'package:gestionafacil_v3/models/encabezadoPedido.dart';
import 'package:gestionafacil_v3/models/producto.dart';
import 'package:gestionafacil_v3/models/proveedor.dart';
import 'package:http/http.dart' as http;

class PedidosProvider extends ChangeNotifier {
  final _url = '${dotenv.env['BASE_URL']}/api/pedidos';
  final _token = "${dotenv.env['TOKEN']}";
  List<ProductoModel> listaTemporal = [];

  ProveedorModel proveedor = new ProveedorModel(
    id: '0',
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
      return {"ok": false, "msg": "Ha ocurrido un error"};
    } else {
      return {"ok": true, "msg": "Ha salido muy bien"};
    }
  }

  Future<List<EncabezadoPedidoModel>> mostrarEncabezadosPedidos() async {
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
    final List<EncabezadoPedidoModel> listaEncabezados = [];
    decodedData.forEach((key, value) {
      if (key == 'encabezadosPedidos') {
        final List tmp = value;
        tmp.forEach((valor) {
          listaEncabezados.add(
            new EncabezadoPedidoModel(
                comprobante: valor['comprobante'],
                proveedoreId: valor['proveedoreId'],
                proveedoreString: valor['Proveedore']['nombre'],
                fechaPedido: DateTime.parse(valor['fechaPedido']),
                totalPedido: valor['totalPedido']),
          );
        });
      }
    });

    return listaEncabezados;
  }

  Future<List<DetallePedidoModel>> mostrarArticulosPedido(
      String comprobante) async {
    this.listaTemporal.clear();
    final consulta = await http.get(
      Uri.parse(_url + '/$comprobante'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "x-token": _token
      },
    );
    final Map<String, dynamic> decodedData = jsonDecode(consulta.body);

    if (consulta.statusCode != 200) {
      return [];
    }
    final List<DetallePedidoModel> listaProductos = [];

    decodedData.forEach((key, value) {
      if (key == 'detallePedido') {
        final List tmp = value;
        tmp.forEach((valor) {
          final detalle = new DetallePedidoModel(
            cantidad: double.parse(valor['cantidad'].toString()),
            productoId: valor['productoId'],
            productoString: valor['Producto']['nombre'],
            valorUnitario: double.parse(valor['valorUnitario'].toString()),
          );
          listaProductos.add(detalle);
        });
      }
    });

    return listaProductos;
  }
}
