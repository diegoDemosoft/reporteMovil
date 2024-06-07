using Ilgua.Connection;
using Ilgua.Model;
using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace Ilgua.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Pa_consulta_movimiento_Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public Pa_consulta_movimiento_Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult EjecutarProcedimientoAlmacenado(
        [FromQuery] string pR_UserName,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 100)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pR_UserName", pR_UserName);

                    var resultados = db.Query<Pa_consulta_movimiento_M>("Pa_consulta_movimiento", parameters, commandType: CommandType.StoredProcedure);

                    // Filtrar registros donde Vendedor termine con "Central" y aplicar paginación
                    var filteredResults = resultados
                                          .Where(model => model.Vendedor != null && model.Vendedor.EndsWith("Central"))
                                          .ToList(); 

                    // Calcular el total de páginas
                    var totalItems = filteredResults.Count;
                    var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

                    // Validar el número de página
                    if (pageNumber < 1)
                        pageNumber = 1;
                    else if (pageNumber > totalPages)
                        pageNumber = totalPages;


                    var paginatedResults = filteredResults
                                            .Skip((pageNumber - 1) * pageSize)
                                            .Take(pageSize)
                                            .Select(model => new
                                            {
                                               model.Fecha_Documento,
                                               model.Producto,
                                               model.UM,
                                               model.Clase,
                                               model.Vendedor,
                                               model.Cliente,
                                               model.Documento,
                                               model.TipoTransaccion,
                                               model.SerieDocto,
                                               model.VtaSinIva,
                                               model.Cantidad,
                                           });

                    return Ok(paginatedResults);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
