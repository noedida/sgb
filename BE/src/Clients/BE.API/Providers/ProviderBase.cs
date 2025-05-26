using BE.Infrastructure.SqlServer.Data;

namespace BE.Clients.Providers
{
    public class ProviderBase
    {
        public readonly IConfiguration _config;
        public ProviderBase(IConfiguration config)
        {
            _config = config;
            AsignaVariablesGlobales();

        }

        public void AsignaVariablesGlobales()
        {
            Globales.KeyJwt = _config["Jqt:Key"];
            Globales.IssueJwt = _config["Jwt:Issuer"];
        }
    }
}


