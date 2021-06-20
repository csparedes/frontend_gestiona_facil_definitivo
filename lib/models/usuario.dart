// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  String id;
  String nombre;
  String roleId;
  String email;
  String password;
  bool estado;
  String createdAt;
  String updatedAt;

  UsuarioModel({
    this.id = '',
    required this.nombre,
    required this.roleId,
    required this.email,
    this.password = '',
    this.estado = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json['id'],
        nombre: json["nombre"],
        roleId: json["roleId"].toString(),
        email: json["email"],
        password: json["password"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "nombre": nombre,
        "roleId": roleId,
        "email": email,
        "password": password,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
