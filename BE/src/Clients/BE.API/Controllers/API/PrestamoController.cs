using BE.API.Controllers;
using BE.Domain.Contract;
using BE.Models.Request;
using BE.Models.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BE.Clients.Controllers.API
{
    [Route(Router.UriPrestamoLibro.Prefijo)]
    [ApiController]
    [Authorize]
    public class PrestamoLibroController : Controller
    {
        private readonly ILogger<PrestamoLibroController> _logger;
        private readonly IPrestamoDomain _prestamoDomain;
        public PrestamoLibroController(ILogger<PrestamoLibroController> logger, IPrestamoDomain prestamoDomain)
        {
            _logger = logger;
            _prestamoDomain = prestamoDomain;
        }


        [HttpPost]
        [Route(Router.UriPrestamoLibro.AprobacionPrestamoLibro)]
        public IActionResult AprobarPrestamo(AprobacionPrestamoRequest oAprobacionPrestamoRequest)
        {
            bool respuesta = false;
            respuesta = _prestamoDomain.AprobarPrestamo(oAprobacionPrestamoRequest);
            if (!respuesta) return NotFound();
            return Ok(respuesta);
        }

        [HttpPost]
        [Route(Router.UriPrestamoLibro.SolicitudPrestamoLibro)]
        public IActionResult RegistrarSolicitudPrestamo(SolicitudPrestamoRequest oSolicitudPrestamoRequest)
        {
            bool respuesta = false;
            respuesta = _prestamoDomain.RegistrarSolicitudPrestamo(oSolicitudPrestamoRequest);
            if (!respuesta) return NotFound();
            return Ok(respuesta);
        }
    }
}



