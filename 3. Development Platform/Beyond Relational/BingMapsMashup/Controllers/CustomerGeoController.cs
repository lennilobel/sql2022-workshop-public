using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using Microsoft.SqlServer.Types;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace BingMapsMashup
{
	public class Customer
	{
		public string Name { get; set; }
		public string Company { get; set; }
		public double Latitude { get; set; }
		public double Longitude { get; set; }
	}
	
	public class CustomerGeoController
    {
        private readonly AppConfig _config;

        public CustomerGeoController(IOptions<AppConfig> config)
        {
            this._config = config.Value;
        }

        [HttpGet]
        [Route("api/customerGeo")]
        public async Task<IEnumerable<Customer>> GetCustomers()
        {
            var customers = new List<Customer>();

			using var conn = new SqlConnection(this._config.DatabaseConnectionString);
			conn.Open();

			using var cmd = new SqlCommand("GetCustomers", conn);
			cmd.CommandType = CommandType.StoredProcedure;

			using var rdr = await cmd.ExecuteReaderAsync();
			while (rdr.Read())
			{
				var geo = SqlGeography.Deserialize(rdr.GetSqlBytes(2));

				var customer = new Customer
				{
					Name = rdr.GetSqlString(0).Value,
					Company = rdr.GetSqlString(1).Value,
					Latitude = geo.Lat.Value,
					Longitude = geo.Long.Value
				};

				customers.Add(customer);
			}
			rdr.Close();

			conn.Close();

			return customers;
		}

    }
}
