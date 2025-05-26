using BE.Models.Request;
using BE.Models.Response;

namespace BE.Domain.Contract
{
    public interface IDevolucionLibroDomain : IDisposable
    {
        bool DevolucionLibro(DevolucionLibroRequest oDevolucionLibroRequest);
    }
}


