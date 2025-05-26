using Microsoft.Extensions.Configuration;

namespace BE.Repository.Contract
{
    public class dbContext
    {
        private readonly IConfiguration _configuration;

        public dbContext(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GetConnectionString()
        {
            return _configuration.GetConnectionString("ConexionSQL");
        }
    }
}
