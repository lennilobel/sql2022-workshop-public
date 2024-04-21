using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using System.IO;

namespace BingMapsMashup
{
	public class Program
	{
		public static void Main(string[] args)
		{
			var builder = WebApplication.CreateBuilder(args);

			builder.Services.AddControllers();
			builder.Services.AddEndpointsApiExplorer();
			builder.Services.AddSwaggerGen();
			builder.Services.AddOptions();
			builder.Services.Configure<AppConfig>(builder.Configuration.GetSection("AppConfig"));

			builder.Services.AddCors(options =>
			{
				options.AddPolicy("AllowAnyCorsPolicy", builder => {
					builder
						.AllowAnyOrigin()
						.AllowAnyMethod()
						.AllowAnyHeader();
				});
			}); 
			
			var app = builder.Build();

			app.UseSwagger();
			app.UseSwaggerUI();
			app.UseCors("AllowAnyCorsPolicy");
			app.UseFileServer(new FileServerOptions
			{
				FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "StaticFiles")),
				RequestPath = "/StaticFiles"
			}); 
			app.UseHttpsRedirection();
			app.MapControllers();
			app.Run();
		}
	}
}
