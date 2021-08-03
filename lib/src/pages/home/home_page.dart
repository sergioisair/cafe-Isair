import 'dart:math';

import 'package:anitex/anitex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:prueba_tienda/src/models/product.dart';
import 'package:prueba_tienda/src/pages/cart/cart.dart';
import 'package:prueba_tienda/src/pages/info_product/info_product_page.dart';
import 'package:prueba_tienda/src/widgets/infoRestaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  List<String> nombreTipo = [
    "CAFÉS",
    "SNACKS",
    "PIZZAS",
    "BEBIDAS",
    "MALTEADAS",
    "POSTRES",
    "SUSHIS"
  ];

  List<int> indexes = [0, 0, 0, 0, 0, 0, 0];
  int menuActual = 0;

  List<List<Product>> listaTotalProductos = new List();
  List<Product> listaProductos = new List();
  Product product;
  List<int> countTipo = [12, 7, 6, 6, 5, 6, 6];
  int countMenus = 7;

  Cart carrito = new Cart();

  @override
  Widget build(BuildContext context) {
    setState(() {});
    loadProductos();

    return DefaultTabController(
      length: countMenus,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: _appBar(),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              child: _swiperTypeMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: InfoRestaurant(),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Icon(
            Icons.apps,
            color: Colors.black,
          ),
          iconSize: 40,
          onPressed: () {
            List<dynamic> arg = [carrito, nombreTipo, listaTotalProductos];
            Navigator.of(context)
                .pushNamed("sec-category", arguments: arg)
                .then((value) => setState(() {}));
          }),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_bag,
                color: Colors.black,
              ),
              iconSize: 40,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('cart', arguments: carrito)
                    .then((value) => setState(() {}));
              },
            ),
            if (carrito.products.length > 0)
              Container(
                alignment: Alignment.bottomRight,
                width: 20,
                child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 15,
                    child: Text(
                      "${carrito.products.length}",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    )),
              )
          ],
        )
      ],
      bottom: TabBar(
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        isScrollable: true,
        tabs: [
          for (int n = 0; n < nombreTipo.length; n++) Tab(text: nombreTipo[n])
        ],
        onTap: (a) {
          menuActual = a;
        },
      ),
    );
  }

  Widget _infoProduct(int indexT) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: 
                EdgeInsets.only(top: MediaQuery.of(context).size.height) * 0.03,
            width: double.infinity,
            child: AnimatedText(
              listaTotalProductos[indexT][indexes[indexT]].nombre,
              useOpacity: false,
              positionCurve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 600),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.075,
                fontFamily: "Pacifico",
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: AnimatedText(
              "\$ ${listaTotalProductos[indexT][indexes[indexT]].precio.split("|")[0]} ",
              duration: Duration(milliseconds: 300),
              useOpacity: false,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontFamily: "TrainOne",
                  color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _swiperTypeMenu() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        _swiperProductsCafe(0),
        _swiperProductsCafe(1),
        _swiperProductsPizza(2),
        _swiperProductsCafe(3),
        _swiperProductsMalteada(4),
        _swiperProductsSnacks(5),
        _swiperProductsSushi(6),
      ],
    );
  }

  Widget _swiperProductsCafe(int indexTipo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _infoProduct(indexTipo),
        Swiper(
          index: indexes[indexTipo],
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'coffee${listaTotalProductos[indexTipo][index].id}',
                  child: Image.asset(
                    listaTotalProductos[indexTipo][index].img,
                  ),
                ),
              ],
            );
          },
          itemCount: countTipo[indexTipo],
          itemWidth: MediaQuery.of(context).size.width,
          scrollDirection: Axis.vertical,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -3, stateCount: 5)
              .addOpacity([0, 1, 1, 1, 1]).addTranslate([
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 245),
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 205),
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 120),
            new Offset(0.0, MediaQuery.of(context).size.height * 0.18),
            new Offset(0.0, (MediaQuery.of(context).size.height + 150)),
          ]).addScale([0.1, 0.2, 0.5, 1, 3], Alignment.center),
          onTap: (index) {
            List<dynamic> arg = [
              listaTotalProductos[indexTipo][indexes[menuActual]],
              carrito,
            ];
            Navigator.pushNamed(context, "product", arguments: arg)
                .then((value) => setState(() {}));
          },
          onIndexChanged: (index) {
            setState(() {
              indexes[menuActual] = index;
            });
          },
          pagination: SwiperPagination(
            margin: EdgeInsets.only(
                left: 5, bottom: MediaQuery.of(context).size.height * 0.075),
            alignment: Alignment.bottomLeft,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.black,
              size: 2.5,
              space: 2.5,
              activeSize: 5.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "${nombreTipo[indexTipo]}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    letterSpacing: 3),
              )),
        ),
      ],
    );
  }

  Widget _swiperProductsPizza(int indexTipo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _infoProduct(indexTipo),
        Swiper(
          index: indexes[indexTipo],
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'coffee${listaTotalProductos[indexTipo][index].id}',
                  child: Image.asset(
                    listaTotalProductos[indexTipo][index].img,
                  ),
                ),
              ],
            );
          },
          itemCount: countTipo[indexTipo],
          itemWidth: MediaQuery.of(context).size.width * 0.75,
          scrollDirection: Axis.horizontal,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -2, stateCount: 5)
              .addOpacity([0.5, 0.5, 1, 0.5, 0.5]).addTranslate([
            new Offset(-MediaQuery.of(context).size.width,MediaQuery.of(context).size.height * 0.1),
            new Offset(-MediaQuery.of(context).size.width * 0.55,MediaQuery.of(context).size.height * 0.1),
            new Offset(0, MediaQuery.of(context).size.height * 0.1),
            new Offset(MediaQuery.of(context).size.width * 0.55,MediaQuery.of(context).size.height * 0.1),
            new Offset(MediaQuery.of(context).size.width ,MediaQuery.of(context).size.height * 0.1),
          ]).addScale([0.4, 0.4, 1, 0.4, 0.4], Alignment.center).addRotate([-2, -1, 0, 1, 2]),
          onTap: (index) {
            List<dynamic> arg = [
              listaTotalProductos[indexTipo][indexes[menuActual]],
              carrito,
            ];
            Navigator.pushNamed(context, "product", arguments: arg)
                .then((value) => setState(() {}));
          },
          onIndexChanged: (index) {
            setState(() {
              indexes[menuActual] = index;
            });
          },
          pagination: SwiperPagination(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.07),
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.black,
              size: 2.5,
              space: 2.5,
              activeSize: 5.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "${nombreTipo[indexTipo]}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    letterSpacing: 3),
              )),
        ),
      ],
    );
  }

    Widget _swiperProductsMalteada(int indexTipo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _infoProduct(indexTipo),
        Swiper(
          index: indexes[indexTipo],
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'coffee${listaTotalProductos[indexTipo][index].id}',
                  child: Image.asset(
                    listaTotalProductos[indexTipo][index].img,
                  ),
                ),
              ],
            );
          },
          itemCount: countTipo[indexTipo],
          itemWidth: MediaQuery.of(context).size.width * 0.75,
          scrollDirection: Axis.horizontal,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -2, stateCount: 5)
              .addOpacity([0.5, 0.5, 1, 0.5, 0.5]).addTranslate([
            new Offset(-MediaQuery.of(context).size.width * 0.7,MediaQuery.of(context).size.height * 0.3),
            new Offset(-MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.2),
            new Offset(MediaQuery.of(context).size.width * 0, MediaQuery.of(context).size.height * 0.1),
            new Offset(MediaQuery.of(context).size.width * 0.35,MediaQuery.of(context).size.height * 0.2),
            new Offset(MediaQuery.of(context).size.width * 0.7,MediaQuery.of(context).size.height * 0.3),
          ]).addScale([0.4, 0.4, 1.2, 0.4, 0.4], Alignment.center).addRotate([-1, -0.5, 0, 0.5, 1]),
          onTap: (index) {
            List<dynamic> arg = [
              listaTotalProductos[indexTipo][indexes[menuActual]],
              carrito,
            ];
            Navigator.pushNamed(context, "product", arguments: arg)
                .then((value) => setState(() {}));
          },
          onIndexChanged: (index) {
            setState(() {
              indexes[menuActual] = index;
            });
          },
          pagination: SwiperPagination(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.07),
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.black,
              size: 2.5,
              space: 2.5,
              activeSize: 5.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "${nombreTipo[indexTipo]}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    letterSpacing: 3),
              )),
        ),
      ],
    );
  }

  Widget _swiperProductsSushi(int indexTipo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _infoProduct(indexTipo),
        Swiper(
          index: indexes[indexTipo],
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'coffee${listaTotalProductos[indexTipo][index].id}',
                  child: Image.asset(
                    listaTotalProductos[indexTipo][index].img,
                  ),
                ),
              ],
            );
          },
          itemCount: countTipo[indexTipo],
          itemWidth: MediaQuery.of(context).size.width*0.9,
          scrollDirection: Axis.vertical,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -4, stateCount: 6)
              .addOpacity([1, 1, 1, 1, 1, 1]).addTranslate([
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 100),
            new Offset(0.0, MediaQuery.of(context).size.height * 0.15 - 200),
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 170),
            new Offset(0.0, (MediaQuery.of(context).size.height * 0.15) - 100),
            new Offset(0.0, MediaQuery.of(context).size.height * 0.18),
            new Offset(0.0, (MediaQuery.of(context).size.height + 200)),
          ]).addScale([0.2, 0.1, 0.2, 0.5, 1, 3], Alignment.center).addRotate(
                  [1, 1, 0, -1, 0, 1]),
          onTap: (index) {
            List<dynamic> arg = [
              listaTotalProductos[indexTipo][indexes[menuActual]],
              carrito,
            ];
            Navigator.pushNamed(context, "product", arguments: arg)
                .then((value) => setState(() {}));
          },
          onIndexChanged: (index) {
            setState(() {
              indexes[menuActual] = index;
            });
          },
          pagination: SwiperPagination(
            margin: EdgeInsets.only(
                left: 5, bottom: MediaQuery.of(context).size.height * 0.075),
            alignment: Alignment.bottomLeft,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.black,
              size: 2.5,
              space: 2.5,
              activeSize: 5.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "${nombreTipo[indexTipo]}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    letterSpacing: 3),
              )),
        ),
      ],
    );
  }

  Widget _swiperProductsSnacks(int indexTipo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height) *
              0.25,
          width: double.infinity,
          child: AnimatedText(
            listaTotalProductos[indexTipo][indexes[indexTipo]].nombre,
            useOpacity: false,
            positionCurve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 600),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.075,
              fontFamily: "Pacifico",
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height) * 0.5,
          child: AnimatedText(
            "\$ ${listaTotalProductos[indexTipo][indexes[indexTipo]].precio.split("|")[0]} ",
            duration: Duration(milliseconds: 300),
            useOpacity: false,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.075,
                fontFamily: "TrainOne",
                color: Colors.green),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
              right: MediaQuery.of(context).size.width * 0.15,
              left: MediaQuery.of(context).size.width * 0.15),
          child: Text(
            listaTotalProductos[indexTipo][indexes[indexTipo]].info,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
        ),
        Swiper(
          index: indexes[indexTipo],
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'coffee${listaTotalProductos[indexTipo][index].id}',
                  child: Image.asset(
                    listaTotalProductos[indexTipo][index].img,
                  ),
                ),
              ],
            );
          },
          itemCount: countTipo[indexTipo],
          itemWidth: MediaQuery.of(context).size.width * 0.75,
          scrollDirection: Axis.vertical,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -2, stateCount: 5)
              .addOpacity([0.5, 0.5, 1, 0.5, 0.5]).addTranslate([
            new Offset(0, -MediaQuery.of(context).size.height * 1),
            new Offset(0, -MediaQuery.of(context).size.height * 0.25),
            new Offset(0, MediaQuery.of(context).size.height * 0.05),
            new Offset(0, MediaQuery.of(context).size.height * 0.35),
            new Offset(0, MediaQuery.of(context).size.height * 1),
          ]).addScale([0.4, 0.4, 1, 0.4, 0.4], Alignment.center),
          onTap: (index) {
            List<dynamic> arg = [
              listaTotalProductos[indexTipo][indexes[menuActual]],
              carrito,
            ];
            Navigator.pushNamed(context, "product", arguments: arg)
                .then((value) => setState(() {}));
          },
          onIndexChanged: (index) {
            setState(() {
              indexes[menuActual] = index;
            });
          },
          pagination: SwiperPagination(
            margin: EdgeInsets.only(
                left: 5, bottom: MediaQuery.of(context).size.height * 0.075),
            alignment: Alignment.bottomLeft,
            builder: DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: Colors.black,
              size: 2.5,
              space: 2.5,
              activeSize: 5.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "${nombreTipo[indexTipo]}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    letterSpacing: 3),
              )),
        ),
      ],
    );
  }

  void loadProductos() {
    listaTotalProductos.clear();
    listaProductos.clear();
    // AGREGAR CAFES
    product = Product(
        id: "00",
        nombre: "Café Americano",
        precio: "30|40|50",
        img: "assets/img/00.png",
        tam: "CHICO|MEDIANO|GRANDE",
        info: "Café clásico Americano, regular y descafeinado",
        sabor: "LECHE ENTERA|LECHE DESLACTOSADA|LECHE LIGHT",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "01",
        nombre: "Café Helado",
        precio: "65|80",
        img: "assets/img/01.png",
        tam: "CHICO|GRANDE",
        info: "Café frío con leche y crema chantillí",
        sabor: "LECHE ENTERA|LECHE DESLACTOSADA|LECHE LIGHT",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "02",
        nombre: "Latte Macchiato",
        precio: "40|55",
        img: "assets/img/02.png",
        tam: "CHICO|GRANDE",
        info: "Latte con una exquisita combinación",
        sabor: "LECHE ENTERA|LECHE DESLACTOSADA|LECHE LIGHT",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "03",
        nombre: "Frappé Caramelo",
        precio: "40|60",
        img: "assets/img/03.png",
        tam: "CHICO|GRANDE",
        info: "Suave frappé de caramelo servido con trocitos de nuez",
        sabor: "NORMAL",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "04",
        nombre: "Café Latte",
        precio: "30|40|50",
        img: "assets/img/04.png",
        tam: "CHICO|MEDIANO|GRANDE",
        info: "Latte clásico, distintos tamaños",
        sabor: "NORMAL",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "05",
        nombre: "Café Cappuccino",
        precio: "30|40",
        img: "assets/img/05.png",
        tam: "CHICO|GRANDE",
        info: "Café cappuccino, un poco espumoso",
        sabor: "CON LECHE|SIN LECHE",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "06",
        nombre: "Café con hielos",
        precio: "30|40",
        img: "assets/img/06.png",
        tam: "CHICO|GRANDE",
        info: "Un café servidor con hielos y chantillí con canela",
        sabor: "CON HIELOS|SIN HIELOS",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "07",
        nombre: "Café Expresso",
        precio: "65",
        img: "assets/img/07.png",
        tam: "NORMAL",
        info: "Café expresso suave",
        sabor: "SIN LECHE|ENTERA|DESLACTOSADA|LIGHT",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "08",
        nombre: "Frappé Clásico",
        precio: "40|65",
        img: "assets/img/08.png",
        tam: "CHICO|GRANDE",
        info: "Frappuccino clásico sabor café",
        sabor: "CON NUEZ|SIN NUEZ",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "09",
        nombre: "Café Helado Mokka",
        precio: "40|55",
        img: "assets/img/09.png",
        tam: "CHICO|GRANDE",
        info: "Café sabor Mokka servido con hielos",
        sabor: "CON HIELOS|SIN HIELOS",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "010",
        nombre: "Café Glace",
        precio: "30|50",
        img: "assets/img/010.png",
        tam: "CHICO|GRANDE",
        info: "Café tipo Glace suave y elegante",
        sabor: "SIN LECHE|ENTERA|DESLACTOSADA|LIGHT",
        tipo: 0);
    listaProductos.add(product);
    product = Product(
        id: "011",
        nombre: "Café Frío de Cereza",
        precio: "20|30",
        img: "assets/img/011.png",
        tam: "CHICO|GRANDE",
        info: "Café frío con chantillí y salsa de cereza de la casa",
        sabor: "SIN LECHE|ENTERA|DESLACTOSADA|LIGHT",
        tipo: 0);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR ENTRADAS
    product = Product(
        id: "10",
        nombre: "Alitas",
        precio: "70|110|140",
        img: "assets/img/10.png",
        tam: "6 PZ|12 PZ|18 PZ",
        info:
            "Deliciosas alitas bañadas en nuestras salsas más exquisitas, incluye aderezo y palitos de apio",
        sabor: "BUFFALO|LEMON|BBQ|DIABLO|HABANERO",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "11",
        nombre: "Papas a la francesa",
        precio: "30|50",
        img: "assets/img/11.png",
        tam: "CHICAS|GRANDES",
        info: "Papas a la francesa crujientes y disponible en varios sabores",
        sabor: "NORMALES|PIMIENTA-LIMON|LIGHT",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "12",
        nombre: "Guacamole",
        precio: "60|85",
        img: "assets/img/12.png",
        tam: "CHICO|GRANDE",
        info:
            "Rico guacamole hecho con Aguacate y Salsa Mexicana, incluye totopos y tortillas para degustar",
        sabor: "C/TOTOPOS|C/TORTILLA",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "13",
        nombre: "Aros de Cebolla",
        precio: "30",
        img: "assets/img/13.png",
        tam: "NORMAL",
        info:
            "Crujientes aros de cebolla empanizados, incluye aderezo y catsup",
        sabor: "NORMAL",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "14",
        nombre: "Tacos dorados",
        precio: "40|60",
        img: "assets/img/14.png",
        tam: "5 PZ|10 PZ",
        info:
            "Orden de taquitos dorados, disponibles de distintos sabores, incluye guacamole y salsa",
        sabor: "PAPA|FRIJOL|POLLO|MIXTO",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "15",
        nombre: "Boneless",
        precio: "60|100",
        img: "assets/img/15.png",
        tam: "200 gr|500 gr",
        info:
            "Calientitos trozos de pollo bañados de nuestras salsas más exquisitas",
        sabor: "BUFFALO|LEMON|BBQ|DIABLO|HABANERO",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "16",
        nombre: "Pan con ajo y queso",
        precio: "35",
        img: "assets/img/16.png",
        tam: "NORMAL",
        info:
            "Trozos de pan horneados con ajo y queso para degustar calientitos",
        sabor: "NORMAL",
        tipo: 1);
    listaProductos.add(product);
    product = Product(
        id: "17",
        nombre: "Hamburguesa",
        precio: "55|75",
        img: "assets/img/17.png",
        tam: "SENCILLA|DOBLE",
        info:
            "Exquisita hamburguesa con ingredientes caseros, además de su jugosa carne a elección",
        sabor: "RES|POLLO|CAMARÓN",
        tipo: 1);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR PIZZAS
    product = Product(
        id: "20",
        nombre: "Pizza Mexicana",
        precio: "95|140",
        img: "assets/img/20.png",
        tam: "CHICA|GRANDE",
        info: "INGREDIENTES: Carne molida, Chorizo, Tocino, Jalapeño y Cebolla",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    product = Product(
        id: "21",
        nombre: "Pizza Pepperoni",
        precio: "95|140",
        img: "assets/img/21.png",
        tam: "CHICA|GRANDE",
        info: "INGREDIENTES: Pepperoni",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    product = Product(
        id: "22",
        nombre: "Pizza de Queso",
        precio: "80|130",
        img: "assets/img/22.png",
        tam: "CHICA|GRANDE",
        info: "INGREDIENTES: 3 tipos de queso derretido y Trocitos de queso",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    product = Product(
        id: "23",
        nombre: "Pizza Italiana",
        precio: "95|140",
        img: "assets/img/23.png",
        tam: "CHICA|GRANDE",
        info:
            "INGREDIENTES: Pepperoni, Jamón, Salami, Salchicha, Pimiento y Champíñon",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    product = Product(
        id: "24",
        nombre: "Pizza Hawaiana",
        precio: "95|140",
        img: "assets/img/24.png",
        tam: "CHICA|GRANDE",
        info: "INGREDIENTES: Piña, Jamón y Salami",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    product = Product(
        id: "25",
        nombre: "Pizza Vegetariana",
        precio: "95|140",
        img: "assets/img/25.png",
        tam: "CHICA|GRANDE",
        info:
            "INGREDIENTES: Pimiento verde, Jitomate, Aceituna negra, Champiñon y Alcachofas",
        sabor: "NORMAL|ORILLA C/QUESO",
        tipo: 2);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR BEBIDAS
    product = Product(
        id: "30",
        nombre: "Naranjada",
        precio: "25|40|80",
        img: "assets/img/30.png",
        tam: "CHICA|GRANDE|JARRA",
        info: "Refrescante naranjada, natural o mineral",
        sabor: "NATURAL|MINERAL",
        tipo: 3);
    listaProductos.add(product);
    product = Product(
        id: "31",
        nombre: "Limonada",
        precio: "25|40|80",
        img: "assets/img/31.png",
        tam: "CHICA|GRANDE|JARRA",
        info: "Refrescante limonada, natural o mineral",
        sabor: "NATURAL|MINERAL",
        tipo: 3);
    listaProductos.add(product);
    product = Product(
        id: "32",
        nombre: "Refresco",
        precio: "15|22",
        img: "assets/img/32.png",
        tam: "CHICO|GRANDE",
        info: "Vaso de refresco a elegir de la familia CocaCola",
        sabor: "FRIO|AL TIEMPO",
        tipo: 3);
    listaProductos.add(product);
    product = Product(
        id: "33",
        nombre: "Jugo Verde",
        precio: "30|40",
        img: "assets/img/33.png",
        tam: "CHICO|GRANDE",
        info: "Rico jugo verde con Naranja, nopal y espinaca",
        sabor: "FRIO|AL TIEMPO",
        tipo: 3);
    listaProductos.add(product);
    product = Product(
        id: "34",
        nombre: "Jugo de Toronja",
        precio: "25|40",
        img: "assets/img/34.png",
        tam: "CHICO|GRANDE",
        info: "Fresco jugo de Toronja totalmente natural",
        sabor: "FRIO|AL TIEMPO",
        tipo: 3);
    listaProductos.add(product);
    product = Product(
        id: "35",
        nombre: "Jugo de Naranja",
        precio: "25|40",
        img: "assets/img/35.png",
        tam: "CHICO|GRANDE",
        info: "Fresco jugo de Naranja totalmente natural",
        sabor: "FRIO|AL TIEMPO",
        tipo: 3);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR MALTEADAS
    product = Product(
        id: "40",
        nombre: "Malteada de Chocolate",
        precio: "35|45",
        img: "assets/img/40.png",
        tam: "CHICA|GRANDE",
        info: "Deliciosa malteada de chocolate (360 ml) disfrútala en cualquiera de sus presentaciones",
        sabor: "NORMAL",
        tipo: 4);
    listaProductos.add(product);
    product = Product(
        id: "41",
        nombre: "Malteada de Fresa",
        precio: "35|45",
        img: "assets/img/41.png",
        tam: "CHICA|GRANDE",
        info: "Deliciosa malteada de fresa (360 ml) disfrútala en cualquiera de sus presentaciones",
        sabor: "NORMAL",
        tipo: 4);
    listaProductos.add(product);
    product = Product(
        id: "42",
        nombre: "Malteada Oreo",
        precio: "40|48",
        img: "assets/img/42.png",
        tam: "CHICA|GRANDE",
        info: "Deliciosa malteada de cookies and cream (360 ml) disfrútala en cualquiera de sus presentaciones",
        sabor: "NORMAL",
        tipo: 4);
    listaProductos.add(product);
    product = Product(
        id: "43",
        nombre: "Malteada Pay de Limón",
        precio: "38|46",
        img: "assets/img/43.png",
        tam: "CHICA|GRANDE",
        info: "Deliciosa malteada de pay de limón (360 ml) disfrútala en cualquiera de sus presentaciones",
        sabor: "NORMAL",
        tipo: 4);
    listaProductos.add(product);
    product = Product(
        id: "44",
        nombre: "Malteada de Vainilla",
        precio: "35|45",
        img: "assets/img/44.png",
        tam: "CHICA|GRANDE",
        info: "Deliciosa malteada de vainilla (360 ml) disfrútala en cualquiera de sus presentaciones",
        sabor: "NORMAL",
        tipo: 4);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR POSTRES
    product = Product(
        id: "50",
        nombre: "Pay de Queso",
        precio: "35|230",
        img: "assets/img/50.png",
        tam: "REBANADA|COMPLETO",
        info: "Delicioso cheesecake con fresas, acompáñalo con un café de nuetra barra de cafés",
        sabor: "NORMAL",
        tipo: 5);
    listaProductos.add(product);
    product = Product(
        id: "51",
        nombre: "Pastel de Chocolate",
        precio: "40|240",
        img: "assets/img/51.png",
        tam: "REBANADA|COMPLETO",
        info: "Pan, crema y cobertura de chocolate semi amargo. Servido con durazno y un toque de salsa de naranja",
        sabor: "NORMAL",
        tipo: 5);
    listaProductos.add(product);
    product = Product(
        id: "52",
        nombre: "Pastel de Café",
        precio: "45|230",
        img: "assets/img/52.png",
        tam: "REBANADA|COMPLETO",
        info: "Suave pastel de café servido y trufa, acompañalo con una de nuestras malteadas",
        sabor: "NORMAL",
        tipo: 5);
    listaProductos.add(product);
    product = Product(
        id: "53",
        nombre: "Pay de Limón",
        precio: "35|245",
        img: "assets/img/53.png",
        tam: "REBANADA|COMPLETO",
        info: "El tradicional pay de limón de la casa",
        sabor: "NORMAL",
        tipo: 5);
    listaProductos.add(product);
    product = Product(
        id: "54",
        nombre: "Crepa con Plátano",
        precio: "50",
        img: "assets/img/54.png",
        tam: "NORMAL",
        info: "Tres crepas, rellenas de queso crema, bañadas con cajeta y trozos de nuez; servidas con plátano y una bola de helado de vainilla",
        sabor: "LECHERA|CAJETA|NUTELLA|CHOCOLATE",
        tipo: 5);
    listaProductos.add(product);
    product = Product(
        id: "55",
        nombre: "Crepa con Fresas",
        precio: "55",
        img: "assets/img/55.png",
        tam: "NORMAL",
        info: "Tres crepas rellenas de queso crema y chocolate liquido, bañadas con salsa y trozos de fresa",
        sabor: "LECHERA|CAJETA|NUTELLA|CHOCOLATE",
        tipo: 5);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
    listaProductos = new List();
    // AGREGAR SUSHIS
    product = Product(
        id: "60",
        nombre: "Sushi Maki",
        precio: "80|150",
        img: "assets/img/60.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi con camarón, verduras mixtas y aguacate por dentro, alga por fuera bañado con salsa dulce y ajonjolí",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    product = Product(
        id: "61",
        nombre: "Sushi California",
        precio: "89|159",
        img: "assets/img/61.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi con pepino y aguacate por dentro y ajonjolí por fuera, 10 piezas",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    product = Product(
        id: "62",
        nombre: "Sushi Empanizado",
        precio: "85|150",
        img: "assets/img/62.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi con cangrejo y aguacate por dentro, queso crema y empanizado por fuera",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    product = Product(
        id: "63",
        nombre: "Sushi Salmón",
        precio: "95|170",
        img: "assets/img/63.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi de pepino y aguacate por dentro, queso crema y salmón por fuera",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    product = Product(
        id: "64",
        nombre: "Sushi Chilli Maki",
        precio: "90|160",
        img: "assets/img/64.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi de camarón con chipotle, queso crema y kakiague por dentro y aguacate por fuera",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    product = Product(
        id: "65",
        nombre: "Sushi Dragon Maki",
        precio: "110|190",
        img: "assets/img/65.png",
        tam: "10 PZ|20 PZ",
        info: "Sushi de pepino, aguacate, camarón y cangrejo por dentro, mango por fuera bañado con salsa dulce y chile piquín",
        sabor: "CAMARÓN|SALMÓN|CANGREJO",
        tipo: 6);
    listaProductos.add(product);
    listaTotalProductos.add(listaProductos);
  }
}
