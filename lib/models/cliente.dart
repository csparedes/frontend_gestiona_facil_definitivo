// To parse this JSON data, do
//
//     final clienteModel = clienteModelFromJson(jsonString);

import 'dart:convert';

ClienteModel clienteModelFromJson(String str) =>
    ClienteModel.fromJson(json.decode(str));

String clienteModelToJson(ClienteModel data) => json.encode(data.toJson());

class ClienteModel {
  String id;
  String nombre;
  String identificacion;
  String domicilio;
  String email;
  bool estado;
  String createdAt;
  String updatedAt;

  ClienteModel({
    this.id = '',
    required this.nombre,
    required this.identificacion,
    required this.domicilio,
    required this.email,
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        id: json["id"],
        nombre: json["nombre"],
        identificacion: json["identificacion"],
        domicilio: json["domicilio"],
        email: json["email"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "identificacion": identificacion,
        "domicilio": domicilio,
        "email": email,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
