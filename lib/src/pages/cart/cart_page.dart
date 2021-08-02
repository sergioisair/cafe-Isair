import 'package:anitex/anitex.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tienda/src/widgets/infoRestaurant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prueba_tienda/src/models/product.dart';
import 'package:prueba_tienda/src/pages/cart/cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool firstRun = true;
  Cart carrito;
  List<List<Product>> listaTotalProductos;
  int precioTotal = 0;
  String number = "+523314316355";

  TextEditingController calle = TextEditingController();
  TextEditingController ncasaext = TextEditingController();
  TextEditingController ncasaint = TextEditingController();
  TextEditingController colonia = TextEditingController();
  TextEditingController cp = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController telefono = TextEditingController();

  int mesa = -1;

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      firstRun = false;
      carrito = ModalRoute.of(context).settings.arguments;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: _listaPedido(),
        bottomNavigationBar: carrito.products.length > 0
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(0.0, -3),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.22,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _totalPedido(),
                    _hacerPedido(),
                  ],
                ),
              )
            : _hacerPedido());
  }

  Widget _totalPedido() {
    precioTotal = 0;
    for (var n = 0; n < carrito.products.length; n++) {
      precioTotal = precioTotal + int.parse(carrito.products[n].selectedPrecio);
    }
    return Text(
      "Total:  \$ $precioTotal",
      style: TextStyle(color: Colors.green, fontSize: 30),
    );
  }

  Widget _listaPedido() {
    if (carrito.products.length > 0)
      return ListView(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              "ORDEN",
              style: TextStyle(
                  fontSize: 25, letterSpacing: 1, fontFamily: "TrainOne"),
            ),
          ),
          for (var n = 0; n < carrito.products.length; n++)
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    List<dynamic> arg = [
                      n,
                      carrito,
                    ];
                    Navigator.pushNamed(context, "modify-product",
                            arguments: arg)
                        .then((value) => setState(() {}));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(0.0, 8.0),
                          blurRadius: 12.0,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          width: MediaQuery.of(context).size.width * 0.24,
                          child: Image.asset(carrito.products[n].img),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      carrito.products[n].nombre,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${carrito.products[n].selectedSize} - ${carrito.products[n].selectedSabor}",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "\$ ${carrito.products[n].selectedPrecio}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.85,
                    bottom: MediaQuery.of(context).size.width * 0.25,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.grey,
                    onPressed: () {
                      _showDialogDeleteOne(context, n);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
        ],
      );
    else
      return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_food_beverage,
                color: Colors.grey,
                size: MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                "Aun no has ordenado nada",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ));
  }

  Widget _hacerPedido() {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.09,
      child: carrito.products.length > 0
          ? MaterialButton(
              onPressed: () async {
                await _showDialogOrder(context);
              },
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "HACER PEDIDO  ",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Image.asset("assets/img/whatsapp.png",
                      width: MediaQuery.of(context).size.width * 0.065)
                ],
              ),
            )
          : MaterialButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (route) => false);
              },
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "IR AL MENU  ",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.065,
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
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        iconSize: 40,
        onPressed: Navigator.of(context).pop,
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.black,
                ),
                iconSize: 40,
                onPressed: () {
                  if (carrito.products.length > 0) {
                    _showDialogDeleteAll(context);
                    setState(() {});
                  }
                }),
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
    );
  }

  void launchWhatsapp({@required String orden}) async {
    String url = "whatsapp://send?phone=$number&text=$orden";
    await canLaunch(url) ? launch(url) : print("No se pudo abrir whatsapp");
  }

  Future _showDialogOrder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialogOrder(),
    );
  }

  Widget _buildAlertDialogOrder() {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.53,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("¿Dónde quieres tu pedido?"),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    offset: new Offset(0.0, 8.0),
                    blurRadius: 12.0,
                  )
                ],
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.18,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDialogComerAqui(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(
                      "Para comer aquí",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    offset: new Offset(0.0, 8.0),
                    blurRadius: 12.0,
                  )
                ],
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.18,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDialogServicioDomicilio(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text("Servicio a domicilio",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ))
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.height * 0.05,
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildAlertDialogServicioDomicilio() {
    return AlertDialog(
      title: Text('¿A dónde llegará tu pedido?', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: calle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Calle *',
                  ),
                ),
                TextField(
                  controller: ncasaext,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número Exterior *',
                  ),
                ),
                TextField(
                  controller: ncasaint,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número Interior',
                  ),
                ),
                TextField(
                  controller: colonia,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Colonia *',
                  ),
                ),
                TextField(
                  controller: cp,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'C.P. *',
                  ),
                ),
                Divider(),
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '¿Cómo te llamas? *',
                  ),
                ),
                TextField(
                  controller: telefono,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Teléfono *',
                  ),
                ),
              ]),
        ),
      ),
      actions: [
        MaterialButton(
            child: Text("ATRÁS"),
            textColor: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
              _showDialogOrder(context);
            }),
        MaterialButton(
            child: Text("ORDENAR"),
            textColor: Colors.blue,
            onPressed: () async {
              if (calle.text.length > 0 &&
                  ncasaext.text.length > 0 &&
                  colonia.text.length > 0 &&
                  cp.text.length > 0 &&
                  username.text.length > 0 &&
                  telefono.text.length > 0) {
                String orden = "Hola, quisiera ordenar:\n\n";
                for (int n = 0; n < carrito.products.length; n++) {
                  orden = orden +
                      "*- ${carrito.products[n].nombre} ${carrito.products[n].sabor.split("|").length > 1 ? carrito.products[n].selectedSabor : ""} ${carrito.products[n].tam.split("|").length > 1 ? carrito.products[n].selectedSize : ""} ${carrito.products[n].aditional.length > 0 ? "(NOTAS: " + carrito.products[n].aditional + ")" : ""} = \$${carrito.products[n].selectedPrecio}*\n";
                }
                orden = orden + "\n*TOTAL: \$$precioTotal*";
                orden = orden +
                    "\n\n*Servicio a domicilio*\n${calle.text} Núm. ${ncasaext.text} - ${ncasaint.text}\nCol. ${colonia.text}, C.P. ${cp.text}";
                orden = orden +
                    "\n\nA nombre de *${username.text} - ${telefono.text}*";
                launchWhatsapp(orden: orden);
                Navigator.of(context).pop();
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Column(
                        children: [
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              "No has llenado todos los campos obligatorios",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06),
                            ),
                          ),
                        ],
                      ));
                    });
                await Future.delayed(Duration(milliseconds: 2000));
                Navigator.pop(context);
              }
            }),
      ],
    );
  }

  Widget _buildAlertDialogComerAqui() {
    return AlertDialog(
      title: Text('¿En qué mesa estás?', textAlign: TextAlign.center),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 8; i++)
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          mesa = i;
                        });
                      },
                      child: Text("$i"),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      color: mesa == i ? Colors.black : Colors.white,
                      textColor: mesa == i ? Colors.white : Colors.black,
                    ),
                  MaterialButton(
                    onPressed: () {
                      mesa = 0;
                      setState(() {});
                    },
                    child: Text("Para llevar"),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    color: mesa == 0 ? Colors.black : Colors.white,
                    textColor: mesa == 0 ? Colors.white : Colors.black,
                  ),
                  Divider(),
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '¿Cómo te llamas?',
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        MaterialButton(
            child: Text("ATRÁS"),
            textColor: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
              _showDialogOrder(context);
            }),
        MaterialButton(
            child: Text("ORDENAR"),
            textColor: Colors.blue,
            onPressed: () async {
              if (mesa != -1) {
                String orden = "Hola, quisiera ordenar:\n\n";
                for (int n = 0; n < carrito.products.length; n++) {
                  orden = orden +
                      "*- ${carrito.products[n].nombre} ${carrito.products[n].sabor.split("|").length > 1 ? carrito.products[n].selectedSabor : ""} ${carrito.products[n].aditional.length > 0 ? "(NOTAS: " + carrito.products[n].aditional + ")" : ""} ${carrito.products[n].tam.split("|").length > 1 ? carrito.products[n].selectedSize : ""} = \$${carrito.products[n].selectedPrecio}*\n";
                }
                orden = orden + "\n*TOTAL: \$$precioTotal*";
                orden = orden +
                    "\n\nEntrega en restaurant *${mesa == 0 ? "PARA LLEVAR" : "MESA $mesa"}*";
                orden = orden + "\n\nA nombre de *${username.text}*";
                launchWhatsapp(orden: orden);
                Navigator.of(context).pop();
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Column(
                        children: [
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              "No has seleccionado mesa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06),
                            ),
                          ),
                        ],
                      ));
                    });
                await Future.delayed(Duration(milliseconds: 2000));
                Navigator.pop(context);
              }
            }),
      ],
    );
  }

  Future _showDialogServicioDomicilio(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialogServicioDomicilio(),
    );
  }

  Future _showDialogComerAqui(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialogComerAqui(),
    );
  }

  Future _showDialogDeleteAll(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialogDeleteAll(),
    );
  }

  Widget _buildAlertDialogDeleteAll() {
    return AlertDialog(
      title: Text('¿De verdad deseas eliminar todos los productos?',
          textAlign: TextAlign.center),
      actions: [
        MaterialButton(
            child: Text("CANCELAR"),
            textColor: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        MaterialButton(
            child: Text("ACEPTAR"),
            textColor: Colors.blue,
            onPressed: () {
              carrito.deleteAll();
              setState(() {});
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future _showDialogDeleteOne(BuildContext context, int n) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialogDeleteOne(n),
    );
  }

  Widget _buildAlertDialogDeleteOne(int n) {
    return AlertDialog(
      title: Text('¿De verdad deseas eliminar este producto?',
          textAlign: TextAlign.center),
      content: Container(
        height: MediaQuery.of(context).size.width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Image.asset(carrito.products[n].img),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          carrito.products[n].nombre,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${carrito.products[n].selectedSize} - ${carrito.products[n].selectedSabor}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
            child: Text("CANCELAR"),
            textColor: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        MaterialButton(
            child: Text("ACEPTAR"),
            textColor: Colors.blue,
            onPressed: () {
              carrito.deleteOne(n);
              setState(() {});
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
