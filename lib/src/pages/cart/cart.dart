import 'package:prueba_tienda/src/models/cartProduct.dart';

class Cart {
  List<CartProduct> products = new List();
  Cart();

  void addProduct(CartProduct product) {
    products.add(product);
  }

  void deleteAll() {
    products = new List();
  }

  void deleteOne(int pos) {
    products.removeAt(pos);
  }

  List<CartProduct> getProducts() {
    return products;
  }
}
