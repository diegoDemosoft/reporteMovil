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
    public class Pa_consulta_movimiento_BACKEND02_Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public Pa_consulta_movimiento_BACKEND02_Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult EjecutarProcedimientoAlmacenado()
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                
                    var resultados = db.Query<Pa_consulta_movimiento_BACKEND02_M>("Pa_consulta_movimiento BACKEND02", commandType: CommandType.StoredProcedure);
                
                    var Resultado = resultados.Select(model => new
                    {
                        model.Campo1,
                        model.Campo2,
                    });
                
                    return Ok(Resultado);
                }
            }  
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
