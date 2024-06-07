//Cambiar campos y agregar campos que se desean mostrar en la tabla, los nombres tienen que ser identicos a los de la base de datos
class Pa_consulta_movimiento_M {
  final DateTime fecha_Documento;
  final String producto;
  final String um;
  final String clase;
  final String vendedor;
  final String cliente;
  final String documento;
  final String tipoTransaccion;
  final String serieDocto;
  final double vtaSinIva;
  final double cantidad;
  final double vtaConIva;

//Cambiar campos y agregar campos que se desean mostrar en la tabla, los nombres tienen que ser identicos a los de la base de datos
  Pa_consulta_movimiento_M({
    required this.fecha_Documento,
    required this.producto,
    required this.um,
    required this.clase,
    required this.vendedor,
    required this.cliente,
    required this.documento,
    required this.tipoTransaccion,
    required this.serieDocto,
    required this.vtaSinIva,
    required this.cantidad,
    required this.vtaConIva,
  });

  factory Pa_consulta_movimiento_M.fromJson(Map<String, dynamic> json) {
    return Pa_consulta_movimiento_M(
      fecha_Documento: DateTime.parse(json['fecha_Documento']),
      producto: json['producto'],
      um: json['um'],
      clase: json['clase'],
      vendedor: json['vendedor'],
      cliente: json['cliente'],
      documento: json['documento'],
      tipoTransaccion: json['tipoTransaccion'],
      serieDocto: json['serieDocto'],
      vtaSinIva: json['vtaSinIva'].toDouble(),
      cantidad: json['cantidad'].toDouble(),
      vtaConIva: json['vtaSinIva'] * 1.12.toDouble(),
    );
  }
}
