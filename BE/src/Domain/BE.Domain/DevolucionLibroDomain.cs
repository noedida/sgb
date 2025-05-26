using BE.Domain;
using BE.Domain.Contract;
using BE.Infrastructure.SqlServer.Functions;
using BE.Models.Request;
using BE.Models.Response;
using BE.Repository.Contract;

namespace BE.Domain
{
    public class DevolucionLibroDomain : IDevolucionLibroDomain
    {
        private readonly IDevolucionLibroRepository _devolucionLibroRepository;
        public DevolucionLibroDomain(IDevolucionLibroRepository devolucionLibroRepository)
        {
            _devolucionLibroRepository = devolucionLibroRepository;
        }

        public bool DevolucionLibro(DevolucionLibroRequest oDevolucionLibroRequest)
        {
            bool respuesta = false;
            respuesta = _devolucionLibroRepository.DevolucionLibro(oDevolucionLibroRequest);
            return respuesta;
        }

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }

    }
}


