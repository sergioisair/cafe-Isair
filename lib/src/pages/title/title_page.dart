import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){Navigator.of(context).pushNamed("home");},
                  child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset("assets/img/logo-cafe.png"),
                ),
                _verificarMenu(),
              ],
            ),
          ),
        ));
  }

  Widget _verificarMenu(){
    return Container();
    // VERIFICANDO SI HAY UN MENU Y ES IGUAL
    // DESCARGANDO MENU
    // CLICK PARA EMPEZAR
  }
}
