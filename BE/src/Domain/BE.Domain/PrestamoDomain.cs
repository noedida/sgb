using BE.Domain;
using BE.Domain.Contract;
using BE.Infrastructure.SqlServer.Functions;
using BE.Models.Request;
using BE.Models.Response;
using BE.Repository;
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

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }

    }
}



