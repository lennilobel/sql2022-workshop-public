using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Net;
using System.Threading.Tasks;

namespace DabCreateCosmosDatabase
{
	class Program
	{
		static async Task Main(string[] args)
		{
			Console.WriteLine("Cosmos DB database for Data API Builder demo");
			Console.WriteLine("Press any key...");
			Console.ReadKey(true);
			Console.WriteLine();
			Console.WriteLine("Creating books container in Library database...");

			var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
			var cosmosDbConnectionString = config["CosmosDbConnectionString"];

			var books = JsonConvert.DeserializeObject<JArray>(File.ReadAllText("books.json"));
			var authors = JsonConvert.DeserializeObject<JArray>(File.ReadAllText("authors.json"));

			using (var client = new CosmosClient(cosmosDbConnectionString))
			{
				try
				{
					await client.GetDatabase("Library").DeleteAsync();
				}
				catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
				{
				}

				await client.CreateDatabaseAsync("Library");
				var database = client.GetDatabase("Library");

				await database.CreateContainerAsync("books", "/type", 400);
				var container = client.GetContainer("Library", "books");

				foreach (var book in books)
				{
					await container.CreateItemAsync(book);
				}

				foreach (var author in authors)
				{
					await container.CreateItemAsync(author);
				}
			}

			Console.WriteLine($"Successfully created Cosmos DB Library database and books container with {books.Count} book documents and {authors.Count} author documents");
		}

	}
}
