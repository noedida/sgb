namespace BE.Models.Response
{
    public class SolicitudPrestamoResponse
    {
        public long IdSolicitud { get; set; } 
        public string EstadoSolicitud { get; set; } 
        public string Mensaje { get; set; } 
        public bool EsExitoso { get; set; } 
    }
}
