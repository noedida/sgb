using BE.API.Controllers;
using BE.Domain.Contract;
using BE.Models.Request;
using BE.Models.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BE.Clients.Controllers.API
{
    [Route(Router.UriDevolucionLibro.Prefijo)]
    [ApiController]
    public class DevolucionLibroController : Controller
    {
        private readonly ILogger<DevolucionLibroController> _logger;
        private readonly IDevolucionLibroDomain _devolucionLibroDomain;
        public DevolucionLibroController(ILogger<DevolucionLibroController> logger, IDevolucionLibroDomain devolucionLibroDomain)
        {
            _logger = logger;
            _devolucionLibroDomain = devolucionLibroDomain;
        }


        [HttpPost]
        [Route(Router.UriDevolucionLibro.DevolucionLibro)]
        public IActionResult DevolucionLibro(DevolucionLibroRequest oDevolucionLibroRequest)
        {
            bool respuesta = false;
            respuesta = _devolucionLibroDomain.DevolucionLibro(oDevolucionLibroRequest);
            if (!respuesta) return NotFound();
            return Ok(respuesta);
        }

    }
}


