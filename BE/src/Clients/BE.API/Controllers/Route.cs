namespace BE.API.Controllers
{
    public class Router
    {

        /*public class UriLogin
        {
            public const string Prefijo = "api/login";
            public const string Autenticacion = "Autenticacion";
        }*/

        public class UriDevolucionLibro
        {
            public const string Prefijo = "api/devolucionlibro";
            public const string DevolucionLibro = "devolucionlibro";
        }

        public class UriPrestamoLibro
        {
            public const string Prefijo = "api/prestamolibro";
            public const string AprobacionPrestamoLibro = "aprobacionprestamolibro";
            public const string SolicitudPrestamoLibro = "solicitudprestamolibro";
        }

    }
}


