import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoRestaurant extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Image.asset("assets/img/logo-cafe.png", height: 35),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset("assets/img/logo-cafe.png"),
                          ),
                          Text(
                              "Av. de Ejemplo #1234 \nColonia Falsa  CP. 45454\nTel: (+52) 33 1431 6355"),
                          Divider(
                            height: 40,
                          ),
                          Text(
                              "Aplicación hecha por:\nSergio Isair\n\nInformación de contacto:\nsergioisair@gmail.com\n(+52) 33 1431 6355\nGuadalajara, Jalisco, México"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              onPressed: () async {
                                String msj =
                                    "Hola Sergio Isair, me interesa tu trabajo!!";
                                String url =
                                    "whatsapp://send?phone=+523314316355&text=$msj";
                                await canLaunch(url)
                                    ? launch(url)
                                    : print("No se pudo abrir whatsapp");
                              },
                              child: Text(
                                "¡Contáctame!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      );
  }
}
