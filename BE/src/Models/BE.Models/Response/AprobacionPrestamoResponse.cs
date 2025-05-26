namespace BE.Models.Response
{
    public class AprobacionPrestamoResponse
    {
        public long IdSolicitud { get; set; } 
        public long? IdPrestamoGenerado { get; set; } 
        public string EstadoSolicitud { get; set; } 
        public string Mensaje { get; set; } 
        public bool EsExitoso { get; set; } 
    }
}
