using System;
using System.ComponentModel.DataAnnotations;

namespace BE.Models.Request
{
    public class DevolucionLibroRequest
    {
        [Required(ErrorMessage = "El ID del pr�stamo es obligatorio.")]
        public long IdPrestamo { get; set; } 

        [Required(ErrorMessage = "La fecha de devoluci�n real es obligatoria.")]
        public DateTime FechaDevolucionReal { get; set; } 

        [Required(ErrorMessage = "El estado del libro devuelto es obligatorio.")]
        [StringLength(20)]
        public string EstadoLibroDevuelto { get; set; } 

        public string Observaciones { get; set; } 
    }
}
