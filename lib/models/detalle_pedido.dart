// To parse this JSON data, do
//
//     final detallePedidoModel = detallePedidoModelFromJson(jsonString);

import 'dart:convert';

DetallePedidoModel detallePedidoModelFromJson(String str) =>
    DetallePedidoModel.fromJson(json.decode(str));

String detallePedidoModelToJson(DetallePedidoModel data) =>
    json.encode(data.toJson());

class DetallePedidoModel {
  DetallePedidoModel({
    this.id = 0,
    this.comprobante = 0,
    required this.cantidad,
    required this.productoId,
    this.productoString = '',
    required this.valorUnitario,
    this.estado = true,
  });

  int id;
  int comprobante;
  double cantidad;
  String productoId;
  String productoString;
  double valorUnitario;
  bool estado;

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) =>
      DetallePedidoModel(
        id: json["id"],
        comprobante: json["comprobante"],
        cantidad: json["cantidad"].toDouble(),
        productoId: json["productoId"],
        productoString: json['productoString'],
        valorUnitario: json["valorUnitario"].toDouble(),
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comprobante": comprobante,
        "cantidad": cantidad,
        "productoId": productoId,
        "productoString": productoString,
        "valorUnitario": valorUnitario,
        "estado": estado,
      };
}
