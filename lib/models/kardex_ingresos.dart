// To parse this JSON data, do
//
//     final kardexIngresoModel = kardexIngresoModelFromJson(jsonString);

import 'dart:convert';

KardexIngresoModel kardexIngresoModelFromJson(String str) =>
    KardexIngresoModel.fromJson(json.decode(str));

String kardexIngresoModelToJson(KardexIngresoModel data) =>
    json.encode(data.toJson());

class KardexIngresoModel {
  String id;
  String productoId;
  String productoString;
  DateTime fecha;
  double cantidad;
  double valorUnitario;
  bool estado;
  String createdAt;
  String updatedAt;

  KardexIngresoModel({
    this.id = '',
    required this.productoId,
    this.productoString = '',
    required this.fecha,
    required this.cantidad,
    required this.valorUnitario,
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory KardexIngresoModel.fromJson(Map<String, dynamic> json) =>
      KardexIngresoModel(
        id: json["id"],
        productoId: json["productoId"],
        productoString: json["productoString"],
        fecha: DateTime.parse(json["fecha"]),
        cantidad: json["cantidad"].toDouble(),
        valorUnitario: json["valorUnitario"].toDouble(),
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productoId": productoId,
        "productoString": productoString,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "cantidad": cantidad,
        "valorUnitario": valorUnitario,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
