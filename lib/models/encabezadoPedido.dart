// To parse this JSON data, do
//
//     final encabezadoPedidoModel = encabezadoPedidoModelFromJson(jsonString);

import 'dart:convert';

EncabezadoPedidoModel encabezadoPedidoModelFromJson(String str) =>
    EncabezadoPedidoModel.fromJson(json.decode(str));

String encabezadoPedidoModelToJson(EncabezadoPedidoModel data) =>
    json.encode(data.toJson());

class EncabezadoPedidoModel {
  EncabezadoPedidoModel({
    this.id = 0,
    required this.comprobante,
    required this.proveedoreId,
    this.proveedoreString = '',
    required this.fechaPedido,
    required this.totalPedido,
    this.comentario = "Sin novedades",
  });

  int id;
  int comprobante;
  String proveedoreId;
  String proveedoreString;
  DateTime fechaPedido;
  double totalPedido;
  String comentario;

  factory EncabezadoPedidoModel.fromJson(Map<String, dynamic> json) =>
      EncabezadoPedidoModel(
        id: json["id"],
        comprobante: json["comprobante"],
        proveedoreId: json["proveedoreId"],
        proveedoreString: json["proveedoreString"],
        fechaPedido: DateTime.parse(json["fechaPedido"]),
        totalPedido: json["totalPedido"].toDouble(),
        comentario: json["comentario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comprobante": comprobante,
        "proveedoreId": proveedoreId,
        "proceedoreString": proveedoreString,
        "fechaPedido":
            "${fechaPedido.year.toString().padLeft(4, '0')}-${fechaPedido.month.toString().padLeft(2, '0')}-${fechaPedido.day.toString().padLeft(2, '0')}",
        "totalPedido": totalPedido,
        "comentario": comentario,
      };
}
