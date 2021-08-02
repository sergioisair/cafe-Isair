import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:prueba_tienda/src/models/product.dart';
import 'package:prueba_tienda/src/pages/cart/cart.dart';
import 'package:prueba_tienda/src/widgets/infoRestaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class SecCategoryPage extends StatefulWidget {
  SecCategoryPage({Key key}) : super(key: key);

  @override
  _SecCategoryPageState createState() => _SecCategoryPageState();
}

class _SecCategoryPageState extends State<SecCategoryPage> {
  List<dynamic> arg;
  bool firstRun = true;
  Cart carrito;
  List<String> nombreTipo;
  List<List<Product>> listaTotalProductos;

  int menu = 0;

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      List<dynamic> arg = ModalRoute.of(context).settings.arguments;
      carrito = arg[0];
      nombreTipo = arg[1];
      listaTotalProductos = arg[2];

      firstRun = false;
    }
    return DefaultTabController(
      length: nombreTipo.length,
      child: Scaffold(
        appBar: _appBar(),
        body: muestraProductos(),
        backgroundColor: Colors.white,
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
          Icons.auto_awesome_motion,
          color: Colors.black,
        ),
        iconSize: 40,
        onPressed: () {
                Navigator.pop(context);
        },
      ),
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
                Navigator.of(context).pushNamed('cart', arguments: carrito).then((value) => setState((){}));
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
      ),
    );
  }

  Widget muestraProductos() {
    return Container(
      width: double.infinity,
      child: TabBarView(
        children: [
          for (int n = 0; n < nombreTipo.length; n++)
            SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: MediaQuery.of(context).size.width * 0.04,
                children: [
                  for (int m = 0; m < listaTotalProductos[n].length; m++)
                    GestureDetector(
                      onTap: () {
                        List<dynamic> arg = [
                          listaTotalProductos[n][m],
                          carrito,
                        ];
                        Navigator.pushNamed(context, "product", arguments: arg).then((value) => setState((){}));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.02,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey,
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                listaTotalProductos[n][m].nombre,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Hero(
                                  tag: "coffee${listaTotalProductos[n][m].id}",
                                  child: Image.asset(
                                      listaTotalProductos[n][m].img)),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
