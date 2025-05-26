using BE.Models.Request;
using BE.Models.Response;

namespace BE.Domain.Contract
{
    public interface IPrestamoDomain : IDisposable
    {
        bool AprobarPrestamo(AprobacionPrestamoRequest oAprobacionPrestamoRequest);
        bool RegistrarSolicitudPrestamo(SolicitudPrestamoRequest oSolicitudPrestamoRequest);
    }
}
