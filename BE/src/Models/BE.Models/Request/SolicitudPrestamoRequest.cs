using System;
using System.ComponentModel.DataAnnotations;

namespace BE.Models.Request
{
    public class SolicitudPrestamoRequest
    {
        [Required(ErrorMessage = "El ID de usuario es obligatorio.")]
        public long IdUsuario { get; set; } 

        [Required(ErrorMessage = "El ID de libro es obligatorio.")]
        public long IdLibro { get; set; } 
    }
}