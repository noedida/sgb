using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BE.Clients.Configurations;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;

namespace BE.Clients.Configurations
{
    public static class SwaggerConfig
    {
        public static void AgregarSwagger(IServiceCollection services)
        {
            services.AddSwaggerGen(options =>
            {
                var groupName = "v1";
                options.SwaggerDoc(groupName, new OpenApiInfo
                {
                    Title = $"Sistema de Gestión de Biblioteca {groupName}",
                    Version = groupName,
                    Description = "SGB API",
                    Contact = new OpenApiContact
                    {
                        Name = "Noe DIAZ",
                        Email = "noedida@gmail.com",
                        Url = new Uri("https://www.linkedin.com/in/noe-diaz-davila/")
                    }
                });
                options.AddSecurityDefinition("bearer", new OpenApiSecurityScheme
                {
                    Type = SecuritySchemeType.Http,
                    BearerFormat = "JWT",
                    In = ParameterLocation.Header,
                    Scheme = "bearer"
                });
                options.OperationFilter<AuthenticationRequirementsOperationFilter>();
            });
        }
    }
}


