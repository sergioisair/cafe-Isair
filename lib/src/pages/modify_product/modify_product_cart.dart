import 'package:anitex/anitex.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tienda/src/models/cartProduct.dart';
import 'package:prueba_tienda/src/pages/cart/cart.dart';
import 'package:prueba_tienda/src/widgets/infoRestaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class ModifyProductCart extends StatefulWidget {
  @override
  _ModifyProductCartState createState() => _ModifyProductCartState();
}

class _ModifyProductCartState extends State<ModifyProductCart> {
  List<String> infoProduct;
  List<String> listTams;
  List<String> listPrices;
  List<String> listSabores;

  String tamFinal;
  String saborFinal;
  String priceFinal;
  TextEditingController editNotes = TextEditingController();

  double tamImg = null;

  CartProduct product;
  int n;

  bool firstRun = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Cart carrito;

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      List<dynamic> arg = ModalRoute.of(context).settings.arguments;
      n = arg[0];
      carrito = arg[1];
      product = carrito.products[n];
      listSabores = product.sabor.split("|");
      listTams = product.tam.split("|");
      listPrices = product.precio.split("|");
      tamFinal = product.selectedSize;
      priceFinal = product.selectedPrecio;
      saborFinal = product.selectedSabor;
      editNotes.text = product.aditional;
      firstRun = false;
      for (int i = 0; i < listTams.length; i++) {
        if (tamFinal == listTams[i])
          tamImg = (MediaQuery.of(context).size.height * 0.05) *
              ((listTams.length) - i - 1);
      }
    }
    print(carrito.getProducts());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Align(child: _textNameProduct(), alignment: Alignment.topRight),
            Align(
              child: _imageProduct(),
              alignment: Alignment.center,
            ),
            Align(child: _sizeProduct(), alignment: Alignment.centerLeft),
            Align(child: _flavourProduct(), alignment: Alignment.centerRight),
            Align(child: _priceProduct(), alignment: Alignment.bottomLeft),
            Align(child: _aditionalNotes(), alignment: Alignment.bottomCenter),
          ],
        ),
      ),
      bottomNavigationBar: _updateProduct(),
    );
  }

  Widget _textNameProduct() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.03),
      child: Text(
        product.nombre,
        textAlign: TextAlign.center,
        style: TextStyle(
            height: 1.2,
            fontSize: product.nombre.length > 7
                ? MediaQuery.of(context).size.width * 0.1
                : MediaQuery.of(context).size.width * 0.15,
            color: Colors.black,
            fontFamily: "Pacifico"),
      ),
    );
  }

  Widget _imageProduct() {
    return AnimatedContainer(
      width: double.infinity,
      duration: Duration(milliseconds: 250),
      height: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: tamImg ?? 0),
      child: Hero(tag: 'coffee${product.id}', child: Image.asset(product.img)),
    );
  }

  Widget _sizeProduct() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Container(), flex: 1),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            child: Text("Tamaño"),
          ),
          for (var a = 0; a != listTams.length; a++)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: tamFinal == listTams[a]
                              ? Colors.black
                              : Colors.black38,
                          width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color:
                      tamFinal == listTams[a] ? Colors.black54 : Colors.white12,
                  onPressed: () {
                    tamFinal = listTams[a];
                    priceFinal = listPrices[a];
                    tamImg = (MediaQuery.of(context).size.height * 0.05) *
                        ((listTams.length) - a - 1);
                    setState(() {});
                  },
                  child: Text("${listTams[a]}",
                      style: TextStyle(color: Colors.white))),
            ),
          Flexible(child: Container(), flex: 5)
        ],
      ),
    );
  }

  Widget _flavourProduct() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(child: Container(), flex: 6),
          for (var a = 0; a != listSabores.length; a++)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: saborFinal == listSabores[a]
                              ? Colors.black
                              : Colors.black38,
                          width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: saborFinal == listSabores[a]
                      ? Colors.black54
                      : Colors.white12,
                  onPressed: () {
                    saborFinal = listSabores[a];
                    setState(() {});
                  },
                  child: Text("${listSabores[a]}",
                      style: TextStyle(color: Colors.white))),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Text("Opción"),
          ),
          Flexible(child: Container(), flex: 1),
        ],
      ),
    );
  }

  Widget _priceProduct() {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.08),
      child: Row(
        children: [
          Text(
            "\$ ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.12,
                color: Colors.green,
                fontFamily: "Pacifico"),
          ),
          AnimatedText(
            "$priceFinal",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.16,
                color: Colors.green,
                fontFamily: "BungeeInline"),
          )
        ],
      ),
    );
  }

  Widget _aditionalNotes() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Agrega información específica que quieres que tenga tu ${product.nombre}",
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: editNotes,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Agrega notas aquí ...',
                      hintText: 'Especifica aquí...'),
                ),
              ),
              actions: [
                MaterialButton(
                    child: Text("BORRAR"),
                    textColor: Colors.red,
                    onPressed: () {
                      editNotes.text = "";
                      setState(() {
                        
                      });
                      Navigator.of(context).pop();
                    }),
                MaterialButton(
                    child: Text("ACEPTAR"),
                    textColor: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          },
        );
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NOTAS ",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.edit,
              color: Colors.grey,
            ),
            Text(
              editNotes.text.length > 0
                  ? editNotes.text
                  : " Clic para agregar notas específicas",
              style: TextStyle(
                  color:
                      editNotes.text.length > 0 ? Colors.black : Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _updateProduct() {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.09,
      child: MaterialButton(
          onPressed: () async {
            carrito.products[n].selectedPrecio = priceFinal;
            carrito.products[n].selectedSabor = saborFinal;
            carrito.products[n].selectedSize = tamFinal;
            carrito.products[n].aditional = editNotes.text;
            setState(() {});
            showDialog(
              barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          "Se ha actualizado tu orden",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                        ),
                      ),
                    ],
                  ));
                });
            await Future.delayed(Duration(milliseconds: 1000));
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ACTUALIZAR  ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.065,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.065,
              ),
            ],
          )),
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
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          iconSize: 40,
          onPressed: () {
            _showDialogDeleteOne(context, n);
          },
        ),
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
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
