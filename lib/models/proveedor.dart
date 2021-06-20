// To parse this JSON data, do
//
//     final proveedorModel = proveedorModelFromJson(jsonString);

import 'dart:convert';

ProveedorModel proveedorModelFromJson(String str) =>
    ProveedorModel.fromJson(json.decode(str));

String proveedorModelToJson(ProveedorModel data) => json.encode(data.toJson());

class ProveedorModel {
  String id;
  String nombre;
  String identificacion;
  String domicilio;
  String email;
  bool estado;
  String createdAt;
  String updatedAt;

  ProveedorModel({
    this.id = '',
    required this.nombre,
    required this.identificacion,
    required this.domicilio,
    required this.email,
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ProveedorModel.fromJson(Map<String, dynamic> json) => ProveedorModel(
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
