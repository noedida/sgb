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
    public class PrestamoRepository : IPrestamoRepository
    {
        #region Variables
        private readonly dbContext _dbContext;
        #endregion

        #region Constructor
        public PrestamoRepository(dbContext dbContext)
        {
            _dbContext = dbContext;
        }
        #endregion

        #region Metodos
        public bool AprobarPrestamo(AprobacionPrestamoRequest oAprobacionPrestamoRequest)
        {
            bool respuesta = false;
            string sp = StoredProcedure.USP_PROCESAR_SOLICITUD_PRESTAMO;
            List<SqlParameterItem> parametros = new List<SqlParameterItem>();
            parametros.Add(new SqlParameterItem("@p_IdSolicitud", SqlDbType.BigInt, oAprobacionPrestamoRequest.IdSolicitud));
            parametros.Add(new SqlParameterItem("@p_IdBibliotecarioAprobador", SqlDbType.BigInt, oAprobacionPrestamoRequest.IdBibliotecarioAprobador));
            parametros.Add(new SqlParameterItem("@p_Aprobado", SqlDbType.Bit, oAprobacionPrestamoRequest.Aprobado));
            parametros.Add(new SqlParameterItem("@p_Observaciones", SqlDbType.Text, oAprobacionPrestamoRequest.Observaciones));
            parametros.Add(new SqlParameterItem("@p_IdCopiaLibro", SqlDbType.BigInt, oAprobacionPrestamoRequest.IdCopiaLibro));
            parametros.Add(new SqlParameterItem("@p_FechaDevolucionPrevista", SqlDbType.DateTime, oAprobacionPrestamoRequest.FechaDevolucionPrevista));
            using (SqlHelperWS db = new SqlHelperWS(_dbContext.GetConnectionString()))
            {
                respuesta = db.ExecuteNonQuery(sp, parametros);
            }
            return respuesta;
        }

        public bool RegistrarSolicitudPrestamo(SolicitudPrestamoRequest oSolicitudPrestamoRequest)
        {
            bool respuesta = false;
            string sp = StoredProcedure.USP_REGISTRAR_SOLICITUD_PRESTAMO;
            List<SqlParameterItem> parametros = new List<SqlParameterItem>();
            parametros.Add(new SqlParameterItem("@p_IdUsuario", SqlDbType.BigInt, oSolicitudPrestamoRequest.IdUsuario));
            parametros.Add(new SqlParameterItem("@p_IdLibro", SqlDbType.BigInt, oSolicitudPrestamoRequest.IdLibro)); 
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



