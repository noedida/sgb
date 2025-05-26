using BE.Domain.Contract;
using BE.Models.Request;
using BE.Repository.Contract;

namespace BE.Domain
{
    public class PrestamoDomain : IPrestamoDomain
    {
        private readonly IPrestamoRepository _prestamoRepository;
        public PrestamoDomain(IPrestamoRepository prestamoRepository)
        {
            _prestamoRepository = prestamoRepository;
        }

        public bool AprobarPrestamo(AprobacionPrestamoRequest oAprobacionPrestamoRequest)
        {
            bool respuesta = false;
            respuesta = _prestamoRepository.AprobarPrestamo(oAprobacionPrestamoRequest);
            return respuesta;
        }

        public bool RegistrarSolicitudPrestamo(SolicitudPrestamoRequest oSolicitudPrestamoRequest)
        {
            bool respuesta = false;
            respuesta = _prestamoRepository.RegistrarSolicitudPrestamo(oSolicitudPrestamoRequest);
            return respuesta;
        }

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }

    }
}



