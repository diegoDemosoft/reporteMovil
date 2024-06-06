import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reporte_movil/Model/Pa_consulta_movimiento_BACKEND02_M.dart';
import 'package:http/http.dart' as http;

class TablaScreen extends StatefulWidget {
  @override
  _TablaScreenState createState() => _TablaScreenState();
}

class _TablaScreenState extends State<TablaScreen> {
  List<Pa_Bsc_Cuenta_Correntista_Movil_M> _datos = [];
  //Cambiar dirección ip y puerto establecido en la publicación del api
  String baseUrl = 'http://192.168.1.20:9092/api/';
  @override
  void initState() {
    super.initState();
  }

  Future<void> _buscarDocumentosPendientes() async {
    setState(() {
      // Establecer isLoading a true al inicio de la carga
    });
    String url =
        '${baseUrl}Pa_Bsc_Cuenta_Correntista_Movil_Ctrl'; // Nombre del controlador

    Uri uri = Uri.parse(url).replace();

    try {
      final response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        // Verificar si la respuesta es una lista
        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<Pa_Bsc_Cuenta_Correntista_Movil_M> datos = jsonResponse
              .map((data) => Pa_Bsc_Cuenta_Correntista_Movil_M.fromJson(data))
              .toList();

          setState(() {
            _datos = datos;
          });
        } else {
          print('Error: La respuesta no es una lista');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabla '),
        ),
        body: SingleChildScrollView(
          child: Material(
            elevation: 5, // Define la elevación del contenedor
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 400, // Define la altura del contenedor
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                        columns: [
                          // Cambiar el nombre de las columnas (El mismo numero de columnas tiene que ser el mismo número de celdas)
                          DataColumn(label: Text('Monto')),
                          DataColumn(label: Text('Aplicar')),
                          DataColumn(label: Text('Valor_Aplicado')),
                          DataColumn(label: Text('Consecutivo_Interno')),
                          DataColumn(label: Text('R_UserName')),
                          DataColumn(label: Text('Cuenta_Corriente')),
                        ],
                        rows: _datos.isNotEmpty
                            // Cambiar el nombre de los campos que se van a mostrar en la tabla, provenientes del model(El mismo numero de celdas tiene que ser el mismo número de columnas)
                            ? List.generate(_datos.length, (index) {
                                List<DataCell> cells = [
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                  DataCell(
                                      Text('${_datos[index].ccDireccion}')),
                                ];

                                return DataRow(cells: cells);
                              })
                            : [])),
              ),
            ),
          ),
        ));
  }
}
