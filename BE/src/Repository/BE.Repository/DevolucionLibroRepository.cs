using BE.Infrastructure.SqlServer.Class;
using BE.Infrastructure.SqlServer.Functions;
using BE.Models.Request;
using BE.Models.Response;
using BE.Repository.Contract;
using BE.Repository.Contract.SqlServer;
using Microsoft.Data.SqlClient;
using System.Data;

namespace BE.Repository
{
    public class DevolucionLibroRepository : IDevolucionLibroRepository
    {
        #region Variables
        private readonly dbContext _dbContext;
        #endregion

        #region Constructor
        public DevolucionLibroRepository(dbContext dbContext)
        {
            _dbContext = dbContext;
        }
        #endregion

        #region Metodos
        public bool DevolucionLibro(DevolucionLibroRequest oDevolucionLibroRequest)
        {
            bool respuesta = false;
            string sp = StoredProcedure.USP_REGISTRAR_DEVOLUCION_LIBRO;
            List<SqlParameterItem> parametros = new List<SqlParameterItem>();
            parametros.Add(new SqlParameterItem("@p_IdPrestamo", SqlDbType.BigInt, oDevolucionLibroRequest.IdPrestamo));
            parametros.Add(new SqlParameterItem("@p_FechaDevolucionReal", SqlDbType.DateTime, oDevolucionLibroRequest.FechaDevolucionReal));
            parametros.Add(new SqlParameterItem("@p_EstadoLibroDevuelto", SqlDbType.VarChar, oDevolucionLibroRequest.EstadoLibroDevuelto));
            parametros.Add(new SqlParameterItem("@p_Observaciones", SqlDbType.Text, oDevolucionLibroRequest.Observaciones));
            using (SqlHelperWS db = new SqlHelperWS(_dbContext.GetConnectionString()))
            {
                respuesta = db.ExecuteNonQuery(sp, parametros);
            }
            return respuesta;
        }        
        #endregion
        
        #region Dispose
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion



    }
}


