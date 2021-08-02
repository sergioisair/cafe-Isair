import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    Product({
        this.id,
        this.nombre,
        this.precio,
        this.img,
        this.tam,
        this.sabor,
        this.tipo,
        this.info
    });

    String nombre;
    String precio;
    String img;
    String tam;
    String sabor;
    int tipo;
    String id;
    String info;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"],
        img: json["img"],
        tam: json["tam"],
        sabor: json["sabor"],
        tipo: json["tipo"],
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
        "info": info,
    };
}