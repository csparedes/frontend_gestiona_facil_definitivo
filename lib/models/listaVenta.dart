import 'package:gestionafacil_v3/models/producto.dart';

class ListaVentaModel {
  final ProductoModel producto;
  final double cantidad;
  final double total;

  const ListaVentaModel({
    required this.producto,
    required this.cantidad,
    required this.total,
  });

  obtenerFilaDetalle(String codigoProducto) {}
}
