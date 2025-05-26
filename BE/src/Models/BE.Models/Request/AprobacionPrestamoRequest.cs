using System;
using System.ComponentModel.DataAnnotations;

namespace BE.Models.Request
{
    public class AprobacionPrestamoRequest
    {
        [Required(ErrorMessage = "El ID de la solicitud es obligatorio.")]
        public long IdSolicitud { get; set; } 

        [Required(ErrorMessage = "El ID del bibliotecario aprobador es obligatorio.")]
        public long IdBibliotecarioAprobador { get; set; } 

        [Required(ErrorMessage = "El estado de aprobación es obligatorio.")]
        public bool Aprobado { get; set; } 

        public string Observaciones { get; set; } 

        public long? IdCopiaLibro { get; set; } 
        public DateTime? FechaDevolucionPrevista { get; set; } 
    }
}
