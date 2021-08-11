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
  bool tieneIva;
  String createdAt;
  String updatedAt;
  double cantidadAux;
  double totalAux;
  String fechaCaducidadAux;

  ProductoModel(
      {this.id = '',
      required this.nombre,
      required this.categoriumId,
      this.categoriumString = '',
      this.codigo = '',
      required this.precioVenta,
      this.tieneIva = false,
      this.estado = true,
      this.createdAt = '',
      this.updatedAt = '',
      this.cantidadAux = 0.0,
      this.totalAux = 0.0,
      this.fechaCaducidadAux = ''});

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        nombre: json["nombre"],
        categoriumId: json["categoriumId"],
        categoriumString: json["categoriumString"],
        codigo: json["codigo"],
        precioVenta: json["precioVenta"].toDouble(),
        estado: json["estado"],
        tieneIva: json['tieneIva'],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        fechaCaducidadAux: json["fechaCaducidadAux"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "categoriumId": categoriumId,
        "categoriumString": categoriumString,
        "codigo": codigo,
        "precioVenta": precioVenta,
        "estado": estado,
        "tieneIva": tieneIva,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "fechaCaducidadAux": fechaCaducidadAux
      };

  void aumentarCantidad() {
    this.cantidadAux++;
    this.totalAux = this.precioVenta * this.cantidadAux;
  }

  void modificarCantidad(String cantidad) {
    this.cantidadAux = double.parse(cantidad);
    this.totalAux = this.precioVenta * this.cantidadAux;
  }

  void modificarPrecio(String precio) {
    this.precioVenta = double.parse(precio);
    this.totalAux = this.precioVenta * this.cantidadAux;
  }

  void disminuirCantidad() {
    this.cantidadAux--;
    if (this.cantidadAux == 0) {
      this.cantidadAux = 0;
    }
    this.totalAux = this.precioVenta * this.cantidadAux;
  }

  void asignarFechaCaducidad(String fecha) => this.fechaCaducidadAux = fecha;
}
