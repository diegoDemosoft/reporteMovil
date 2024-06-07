namespace Ilgua.Model
{
    public class Pa_consulta_movimiento_M
    {
        public DateTime Fecha_Documento { get; set; }
        public string Producto { get; set; }
        public string UM { get; set; }
        public string Clase { get; set; }
        public string Vendedor { get; set; }
        public string Cliente { get; set; }
        public string Documento { get; set; }
        public int Consecutivo { get; set; }
        public String TipoTransaccion { get; set; }
        public string SerieDocto { get; set; }
        public decimal VtaSinIva { get; set; }
        public decimal Cantidad { get; set; }


    }
}
