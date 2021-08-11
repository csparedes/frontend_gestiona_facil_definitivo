// To parse this JSON data, do
//
//     final kardexExistenciaModel = kardexExistenciaModelFromJson(jsonString);

import 'dart:convert';

KardexExistenciaModel kardexExistenciaModelFromJson(String str) =>
    KardexExistenciaModel.fromJson(json.decode(str));

String kardexExistenciaModelToJson(KardexExistenciaModel data) =>
    json.encode(data.toJson());

class KardexExistenciaModel {
  String id;
  String productoId;
  String productoString;
  double productoPrecio;
  String productoCategoria;
  String productoCodigo;
  DateTime fechaCaducidad;
  double cantidad;
  double valorIngreso;
  bool estado;
  String createdAt;
  String updatedAt;

  KardexExistenciaModel({
    this.id = '',
    required this.productoId,
    this.productoString = '',
    this.productoPrecio = 0.0,
    required this.fechaCaducidad,
    required this.cantidad,
    required this.valorIngreso,
    this.productoCategoria = '',
    this.productoCodigo = '',
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory KardexExistenciaModel.fromJson(Map<String, dynamic> json) =>
      KardexExistenciaModel(
        id: json["id"],
        productoId: json["productoId"],
        productoString: json["productoString"],
        productoPrecio: json["produtoPrecio"],
        productoCategoria: json['productoCategoria'],
        productoCodigo: json['productoCodigo'],
        fechaCaducidad: DateTime.parse(json["fechaCaducidad"]),
        cantidad: json["cantidad"].toDouble(),
        valorIngreso: json["valorIngreso"].toDouble(),
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productoId": productoId,
        "productoString": productoString,
        "produtoPrecio": productoPrecio,
        "productoCategoria": productoCategoria,
        "productoCodigo": productoCodigo,
        "fechaCaducidad":
            "${fechaCaducidad.year.toString().padLeft(4, '0')}-${fechaCaducidad.month.toString().padLeft(2, '0')}-${fechaCaducidad.day.toString().padLeft(2, '0')}",
        "cantidad": cantidad,
        "valorIngreso": valorIngreso,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
