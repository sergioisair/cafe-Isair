import 'dart:convert';

CartProduct productFromJson(String str) =>
    CartProduct.fromJson(json.decode(str));

String productToJson(CartProduct data) => json.encode(data.toJson());

class CartProduct {
  CartProduct({
    this.id,
    this.nombre,
    this.precio,
    this.img,
    this.tam,
    this.sabor,
    this.tipo,
    this.selectedSabor,
    this.selectedSize,
    this.selectedPrecio,
    this.aditional,
    this.info
  });

  String nombre;
  String precio;
  String img;
  String tam;
  String sabor;
  int tipo;
  String id;
  String selectedSabor;
  String selectedSize;
  String selectedPrecio;
  String aditional;
  String info;

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"],
        img: json["img"],
        tam: json["tam"],
        sabor: json["sabor"],
        tipo: json["tipo"],
        selectedSabor: json["selectedSabor"],
        selectedSize: json["selectedSize"],
        selectedPrecio: json["selectedPrecio"],
        aditional: json["aditional"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "img": img,
        "tam": tam,
        "sabor": sabor,
        "tipo": tipo,
        "selectedSabor": selectedSabor,
        "selectedSize": selectedSize,
        "selectedPrecio": selectedPrecio,
        "aditional": aditional,
        "info": info,
      };
}
