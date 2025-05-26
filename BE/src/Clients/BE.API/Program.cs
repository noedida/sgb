using BE.Clients.Configurations;
using BE.Domain;
using BE.Domain.Contract;
using BE.Repository;
using BE.Repository.Contract;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

builder.Services.AddScoped<dbContext>();
builder.Services.AddScoped<IDevolucionLibroDomain, DevolucionLibroDomain>();
builder.Services.AddScoped<IDevolucionLibroRepository, DevolucionLibroRepository>();
builder.Services.AddScoped<IPrestamoDomain, PrestamoDomain>();
builder.Services.AddScoped<IPrestamoRepository, PrestamoRepository>();


SwaggerConfig.AgregarSwagger(builder.Services);

var app = builder.Build();

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

app.UseHttpsRedirection();
app.UseCors("CorsPolicy");
app.UseRouting();
app.UseStaticFiles();
app.MapControllers();

app.Run();