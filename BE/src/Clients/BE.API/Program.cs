using BE.Clients.Configurations;
using BE.Domain;
using BE.Domain.Contract;
using BE.Repository;
using BE.Repository.Contract;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Configuración de Controladores
builder.Services.AddControllers();

// Configuración de CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

// Configuración de Autenticación JWT
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])),
            ClockSkew = TimeSpan.Zero
        };
    });

// Inyeccion de dependencias - Singleton
builder.Services.AddScoped<dbContext>();
builder.Services.AddScoped<IDevolucionLibroDomain, DevolucionLibroDomain>();
builder.Services.AddScoped<IDevolucionLibroRepository, DevolucionLibroRepository>();
builder.Services.AddScoped<IPrestamoDomain, PrestamoDomain>();
builder.Services.AddScoped<IPrestamoRepository, PrestamoRepository>();

//builder.Services.AddScoped<GenerarTokenJwt>();

SwaggerConfig.AgregarSwagger(builder.Services);

var app = builder.Build();

// Pipeline de Solicitudes HTTP (Middleware) ---
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    // Middleware de Swagger UI (solo en desarrollo)
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "AtlanticCity v1");
    });
}
else // Para producción
{
    app.UseExceptionHandler("/Error");
}

app.UseAuthentication();
app.UseHttpsRedirection();
app.UseCors("CorsPolicy");
app.UseRouting();
app.UseAuthorization();
app.UseStaticFiles();
app.MapControllers();

app.Run();