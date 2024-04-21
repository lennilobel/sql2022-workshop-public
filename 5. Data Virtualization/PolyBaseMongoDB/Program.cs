using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Threading.Tasks;

namespace PolyBaseMongoDB
{
	class Program
	{
		static async Task Main(string[] args)
		{
			Console.WriteLine("Prepare MongoDB database for SQL Server PolyBase demo");
			Console.WriteLine("Press any key...");
			Console.ReadKey(true);
			Console.WriteLine();
			Console.WriteLine("Creating TaskList collection in FlightTasks database...");

			var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
			var mongoDbApiConnectionString = config["MongoDbApiConnectionString"];
			var client = new MongoClient(mongoDbApiConnectionString);

			// If the database exists, this will delete the database with its collections
			// If the database doesn't exist, this will have no effect (it will not fail)
			await client.DropDatabaseAsync("FlightTasks");

			// If the database exists, this will obtain a reference to it
			// If the database doesn't exist, it will be created automatically (it will not fail)
			var database = client.GetDatabase("FlightTasks");

			// database.CreateCollection() doesn't let you set the shard key (partition key), so we use database.RunCommandAsync instead
			var createCollectionCommand = new BsonDocument
			{
				{ "customAction", "CreateCollection" },
				{ "collection", "TaskList" },
				{ "shardKey", "flightId" }
			};
			await database.RunCommandAsync<BsonDocument>(createCollectionCommand);

			var collection = database.GetCollection<BsonDocument>("TaskList");

			var item1 = new BsonDocument
			{
				{ "flightId", 1 },
				{ "dueDate", "2022-03-01" },
				{ "name", "Task 1/2 for flight 1" }
			};
			await collection.InsertOneAsync(item1);

			var item2 = new BsonDocument
			{
				{ "flightId", 1 },
				{ "dueDate", "2022-03-08" },
				{ "name", "Task 2/2 for flight 1" }
			};
			await collection.InsertOneAsync(item2);

			var item3 = new BsonDocument
			{
				{ "flightId", 3 },
				{ "dueDate", "2022-05-09" },
				{ "name", "Task for flight 3" }
			};
			await collection.InsertOneAsync(item3);

			Console.WriteLine("Successfully created MongoDB FlightTasks database and TaskList collection with three task documents");
		}

	}
}
