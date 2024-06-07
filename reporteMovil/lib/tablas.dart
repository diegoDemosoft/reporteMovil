import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reporte_movil/Model/Pa_consulta_movimiento_M.dart';
import 'package:reporte_movil/loading.dart';
import 'package:intl/intl.dart';

class TablaScreen extends StatefulWidget {
  @override
  _TablaScreenState createState() => _TablaScreenState();
}

class _TablaScreenState extends State<TablaScreen> {
  List<Pa_consulta_movimiento_M> _datos = [];
  bool _cargando = false;
  int pageSize = 10; // Número de registros a mostrar por página
  int pageNumber = 1;
  String baseUrl =
      'http://192.168.1.20:9090/api/'; //cambiar ip y puerto con el que se publico la Api (si se utiliza esta ip la máquina tiene que estar encendida)

  @override
  void initState() {
    super.initState();
    _buscarDocumentosPendientes();
  }

  Future<void> _buscarDocumentosPendientes() async {
    setState(() {
      _cargando = true;
    });
    String url = '${baseUrl}Pa_consulta_movimiento_Ctrl';
    Map<String, dynamic> queryParams = {
      "pR_UserName": "DevGD0201",
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    };
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        // ignore: unnecessary_type_check
        if (jsonResponse is List) {
          List<Pa_consulta_movimiento_M> nuevosDatos = jsonResponse
              .map((data) => Pa_consulta_movimiento_M.fromJson(data))
              .toList();

          setState(() {
            _datos.addAll(
                nuevosDatos); // Agrega los nuevos datos a la lista existente
            pageNumber++; // Incrementa el número de página para la próxima carga
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
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
          child: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(top: 90.0, left: 50.0, right: 50.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, left: 10.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Reporte Movil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Ajusta el número de líneas máximo
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _cargando
          ? Center(child: LoadingComponent()) // indicador de carga
          : SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Producto')),
                              DataColumn(label: Text('Vendedor')),
                              DataColumn(label: Text('Cliente')),
                              DataColumn(label: Text('VentaSinIva')),
                              DataColumn(label: Text('Cantidad')),
                              DataColumn(label: Text('VentaConIva')),
                            ],
                            rows: _datos.isNotEmpty
                                ? List.generate(_datos.length, (index) {
                                    List<DataCell> cells = [
                                      DataCell(
                                          Text('${_datos[index].producto}')),
                                      DataCell(
                                          Text('${_datos[index].vendedor}')),
                                      DataCell(
                                          Text('${_datos[index].cliente}')),
                                      DataCell(Text(NumberFormat('#,##0.00')
                                          .format(_datos[index].vtaSinIva))),
                                      DataCell(
                                          Text('${_datos[index].cantidad}')),
                                      DataCell(Text(NumberFormat('#,##0.00')
                                          .format(_datos[index].vtaConIva))),
                                    ];

                                    return DataRow(cells: cells);
                                  })
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Alinear el botón a la derecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _cargando
                            ? null
                            : () {
                                _buscarDocumentosPendientes();
                              },
                        child: Text('Ver más'),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
