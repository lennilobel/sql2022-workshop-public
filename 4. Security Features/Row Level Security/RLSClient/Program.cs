using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace RLSClient
{
	internal class Program
	{
		private const string ConnStr =
			"data source=.;initial catalog=MyDB;uid=AppLogin;pwd=[PASSWORD];Trust Server Certificate=True;";

		private static string _username;

		static void Main(string[] args)
		{
			System.Diagnostics.Debugger.Break();

			if (!Login())
			{
				Console.WriteLine("Authentication failed; proceeding as anonymous user; press any key to continue");
				Console.ReadKey();
			}
			DisplayOrders();
			Console.WriteLine("Press any key to continue");
			Console.ReadKey();
		}

		public static bool Login()
		{
			System.Diagnostics.Debugger.Break();

			Console.WriteLine("Please login");
			Console.WriteLine();

			Console.Write("Username: ");
			var username = Console.ReadLine();

			Console.Write("Password: ");
			var password = Console.ReadLine();

			Console.WriteLine();

			if (password != "rlsdemo")
			{
				_username = null;
				return false;
			}

			_username = username;
			return true;
		}

		public static void DisplayOrders()
		{
			System.Diagnostics.Debugger.Break();

			Console.WriteLine();
			Console.WriteLine();
			Console.WriteLine("Order list:");

			using var conn = OpenSqlConnection();

			using var cmd = conn.CreateCommand();
			cmd.CommandText = "SELECT * FROM Sales";

			using var rdr = cmd.ExecuteReader();
			var count = 0;
			while (rdr.Read())
			{
				count++;
				Console.WriteLine(" " +
					$"OrderID: {rdr["OrderID"]}; " +
					$"SalesUsername: {rdr["SalesUsername"]}; " +
					$"Product: {rdr["Product"]}; " +
					$"Qty: {rdr["Qty"]}; "
				);
			}
			Console.WriteLine("Total orders: {0}", count);

			conn.Close();
			Console.WriteLine();
		}

		private static SqlConnection OpenSqlConnection()
		{
			var conn = new SqlConnection(ConnStr);
			conn.Open();

			if (_username == null)
			{
				// user is unauthenticated; return an ordinary open connection
				return conn;
			}

			// user is authenticated; set the session context on the open connection for RLS
			try
			{
				using var cmd = new SqlCommand("sp_set_session_context", conn);
				cmd.CommandType = CommandType.StoredProcedure;
				cmd.Parameters.AddWithValue("@key", "AppUsername");
				cmd.Parameters.AddWithValue("@value", _username);
				cmd.Parameters.AddWithValue("@read_only", 1);

				cmd.ExecuteNonQuery();
			}
			catch (Exception)
			{
				conn.Close();
				conn.Dispose();
				throw;
			}

			return conn;
		}

	}
}
