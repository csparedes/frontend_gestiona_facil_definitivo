// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String id;
  String nombre;
  String categoriumId;
  String categoriumString;
  String codigo;
  double precioVenta;
  bool estado;
  String createdAt;
  String updatedAt;
  double cantidadAux;
  double totalAux;

  ProductoModel({
    this.id = '',
    required this.nombre,
    required this.categoriumId,
    this.categoriumString = '',
    required this.codigo,
    required this.precioVenta,
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
    this.cantidadAux = 0.0,
    this.totalAux = 0.0,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        nombre: json["nombre"],
        categoriumId: json["categoriumId"],
        categoriumString: json["categoriumString"],
        codigo: json["codigo"],
        precioVenta: json["precioVenta"].toDouble(),
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "categoriumId": categoriumId,
        "categoriumString": categoriumString,
        "codigo": codigo,
        "precioVenta": precioVenta,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  void aumentarCantidad() {
    this.cantidadAux++;
    this.totalAux = this.precioVenta * this.cantidadAux;
  }

  void disminuirCantidad() {
    this.cantidadAux--;
    if (this.cantidadAux == 0) {
      this.cantidadAux = 0;
    }
    this.totalAux = this.precioVenta * this.cantidadAux;
  }
}
