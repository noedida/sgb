using BE.Models.Request;
using BE.Models.Response;

namespace BE.Repository.Contract
{
    public interface IDevolucionLibroRepository : IDisposable
    {
        bool DevolucionLibro(DevolucionLibroRequest oDevolucionLibroRequest);
    }
}


