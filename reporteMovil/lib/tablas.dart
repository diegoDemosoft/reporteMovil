import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reporte_movil/Model/Pa_consulta_movimiento_M.dart';
import 'package:reporte_movil/loading.dart';

class TablaScreen extends StatefulWidget {
  @override
  _TablaScreenState createState() => _TablaScreenState();
}

class _TablaScreenState extends State<TablaScreen> {
  List<Pa_consulta_movimiento_M> _datos = [];
  bool _cargando = false;
  int pageSize = 50;
  String baseUrl = 'http://192.168.1.20:9090/api/';

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
      "pageNumber": "1",
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

        if (jsonResponse is List) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<Pa_consulta_movimiento_M> datos = jsonResponse
              .map((data) => Pa_consulta_movimiento_M.fromJson(data))
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
      setState(() {
        _cargando = false;
      });
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
      body: _cargando
          ? Center(child: LoadingComponent()) // Agregar indicador de carga
          : SingleChildScrollView(
              child: Material(
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
                                  DataCell(Text('${_datos[index].producto}')),
                                  DataCell(Text('${_datos[index].vendedor}')),
                                  DataCell(Text('${_datos[index].cliente}')),
                                  DataCell(Text('${_datos[index].vtaSinIva}')),
                                  DataCell(Text('${_datos[index].cantidad}')),
                                  DataCell(Text('${_datos[index].vtaConIva}')),
                                ];

                                return DataRow(cells: cells);
                              })
                            : [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
