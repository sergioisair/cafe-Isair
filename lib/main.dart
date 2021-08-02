
import 'package:flutter/material.dart';
import 'package:prueba_tienda/src/pages/cart/cart_page.dart';
import 'package:prueba_tienda/src/pages/home/home_page.dart';
import 'package:prueba_tienda/src/pages/info_product/info_product_page.dart';
import 'package:prueba_tienda/src/pages/modify_product/modify_product_cart.dart';
import 'package:prueba_tienda/src/pages/secondary/category_list_page.dart';
import 'package:prueba_tienda/src/pages/title/title_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Café Isair",
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'product': (BuildContext context) => InfoProduct(),
        'cart': (BuildContext context) => CartPage(),
        'modify-product': (BuildContext context) => ModifyProductCart(),
        'sec-category': (BuildContext context) => SecCategoryPage(),
        'title': (BuildContext context) => TitlePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
