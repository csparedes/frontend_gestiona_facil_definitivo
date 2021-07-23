// To parse this JSON data, do
//
//     final categoriaModel = categoriaModelFromJson(jsonString);

import 'dart:convert';

CategoriaModel categoriaModelFromJson(String str) =>
    CategoriaModel.fromJson(json.decode(str));

String categoriaModelToJson(CategoriaModel data) => json.encode(data.toJson());

class CategoriaModel {
  CategoriaModel({
    this.id = '',
    required this.nombre,
    this.descripcion = 'Nueva Categoria',
    this.estado = true,
  });

  String id;
  String nombre;
  String descripcion;
  bool estado;

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "estado": estado,
      };
}
