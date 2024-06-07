import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingComponent extends StatefulWidget {
  @override
  _LoadingComponentState createState() => _LoadingComponentState();
}

class _LoadingComponentState extends State<LoadingComponent> {
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador y establecer el estado isLoading a true
  }

  @override
  void dispose() {
    // Cancelar el temporizador en el método dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cargando
        ? Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 0, 0, 0),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeBounce(
                    color: Colors.blue[800]!,
                    size: 50.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cargando...',
                    style: TextStyle(color: Color.fromARGB(255, 97, 153, 190)),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(); // Si isLoading es false, no muestra nada
  }
}
