using BE.Models.Request;
using BE.Models.Response;

namespace BE.Repository.Contract
{
    public interface IPrestamoRepository : IDisposable
    {
        bool AprobarPrestamo(AprobacionPrestamoRequest oAprobacionPrestamoRequest);

        bool RegistrarSolicitudPrestamo(SolicitudPrestamoRequest oSolicitudPrestamoRequest)
    }
}



