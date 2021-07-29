// To parse this JSON data, do
//
//     final perchaModel = perchaModelFromJson(jsonString);

import 'dart:convert';

PerchaModel perchaModelFromJson(String str) =>
    PerchaModel.fromJson(json.decode(str));

String perchaModelToJson(PerchaModel data) => json.encode(data.toJson());

class PerchaModel {
  PerchaModel({
    this.id = 0,
    required this.cajaId,
    this.cajaString = '',
    this.unidadesCaja = 0.0,
    required this.articuloId,
    this.articuloString = '',
    this.estado = true,
  });

  int id;
  String cajaId;
  String cajaString;
  double unidadesCaja;
  String articuloId;
  String articuloString;
  bool estado;

  factory PerchaModel.fromJson(Map<String, dynamic> json) => PerchaModel(
        id: json["id"],
        cajaId: json["cajaId"],
        cajaString: json["cajaString"],
        unidadesCaja: json["unidadesCaja"].toDouble(),
        articuloId: json["articuloId"],
        articuloString: json["articuloString"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cajaId": cajaId,
        "cajaString": cajaString,
        "unidadesCaja": unidadesCaja,
        "articuloId": articuloId,
        "articuloString": articuloString,
        "estado": estado,
      };
}
