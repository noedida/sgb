namespace BE.Models.Response
{
    public class DevolucionLibroResponse
    {
        public long IdPrestamo { get; set; } 
        public string Mensaje { get; set; } 
        public bool EsExitoso { get; set; } 
        public decimal? MultaAplicada { get; set; } 
        public string EstadoPrestamo { get; set; } 
    }
}
