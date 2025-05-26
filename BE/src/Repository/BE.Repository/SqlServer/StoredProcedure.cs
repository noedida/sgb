using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace BE.Repository.Contract.SqlServer
{
    public class StoredProcedure
    {
        #region Login
        //public const string USP_USUARIO_AUTH = "sp_AuthenticateUser";
        #endregion

        #region Usuario
        public const string USP_REGISTRAR_DEVOLUCION_LIBRO = "SP_RegistrarDevolucionLibro";
        public const string USP_PROCESAR_SOLICITUD_PRESTAMO = "SP_ProcesarSolicitudPrestamo";
        public const string USP_REGISTRAR_SOLICITUD_PRESTAMO = "SP_RegistrarSolicitudPrestamo";

        #endregion
    }
}


