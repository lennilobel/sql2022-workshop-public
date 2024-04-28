using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace AEClient
{
	internal class Program
	{
		static void Main(string[] args)
		{
			RunDemo();
		}

		private const string PlainConnStr =
			"data source=.;initial catalog=MyEncryptedDB;integrated security=true;Trust Server Certificate=True;";

		private const string AeEnabledConnStr =
			PlainConnStr + "column encryption setting=enabled";

		public static void RunDemo()
		{
			System.Diagnostics.Debugger.Break();

			Console.WriteLine("*** Without Encryption Setting ***");
			Console.WriteLine();
			RunWithoutEncryptionSetting();

			Console.Clear();
			Console.WriteLine("*** With Encryption Setting (T-SQL) ***");
			Console.WriteLine();
			RunWithEncryptionSettingTSql();

			Console.Clear();
			Console.WriteLine("*** With Encryption Setting (stored procedures) ***");
			Console.WriteLine();
			RunWithEncryptionSettingStoredProcs();

			Console.WriteLine("Press any key to continue");
			Console.ReadKey();
		}

		private static void RunWithoutEncryptionSetting()
		{
			using var conn = new SqlConnection(PlainConnStr);
			conn.Open();

			// Can query, but can't read encrypted data returned by the query
			using (var cmd = new SqlCommand("SELECT * FROM Employee", conn))
			{
				using var rdr = cmd.ExecuteReader();
				while (rdr.Read())
				{
					Console.WriteLine("EmployeeId: {0}; Name: {1}; SSN: {2}; Salary: {3}; City: {4}",
						rdr["EmployeeId"], rdr["Name"], rdr["SSN"], rdr["Salary"], rdr["City"]);
				}
				rdr.Close();
			}
			Console.WriteLine();

			// Can't query on Salary
			using (var cmd = new SqlCommand("SELECT * FROM Employee WHERE Salary = @Salary", conn))
			{
				var parm = new SqlParameter("@Salary", SqlDbType.VarChar, 20) { Value = "Doug Nichols" };
				cmd.Parameters.Add(parm);

				try
				{
					cmd.ExecuteScalar();
				}
				catch (Exception ex)
				{
					Console.WriteLine("Failed to run query on Salary column");
					Console.WriteLine(ex.Message);
				}
			}
			Console.WriteLine();

			// Can't query on SSN
			using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Employee WHERE SSN = @SSN", conn))
			{
				var parm = new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "n/a" };
				cmd.Parameters.Add(parm);

				try
				{
					cmd.ExecuteScalar();
				}
				catch (Exception ex)
				{
					Console.WriteLine("Failed to run query on SSN column");
					Console.WriteLine(ex.Message);
				}
			}
			Console.WriteLine();

			// Can't insert encrypted data
			using (var cmd = new SqlCommand("INSERT INTO Employee VALUES(@Name, @SSN, @Salary, @City)", conn))
			{
				var nameParam = new SqlParameter("@Name", SqlDbType.VarChar, 20) { Value = "Steven Jacobs" };
				cmd.Parameters.Add(nameParam);

				var ssnParam = new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "333-22-4444" };
				cmd.Parameters.Add(ssnParam);

				var salaryParam = new SqlParameter("@Salary", SqlDbType.Money) { Value = 57006 };
				cmd.Parameters.Add(salaryParam);

				var cityParam = new SqlParameter("@City", SqlDbType.VarChar, 20) { Value = "Los Angeles" };
				cmd.Parameters.Add(cityParam);

				try
				{
					cmd.ExecuteNonQuery();
				}
				catch (Exception ex)
				{
					Console.WriteLine("Failed to insert new row with encrypted data");
					Console.WriteLine(ex.Message);
				}
			}
			Console.WriteLine();

			conn.Close();
			Console.WriteLine();
		}

		private static void RunWithEncryptionSettingTSql()
		{
			using var conn = new SqlConnection(AeEnabledConnStr);
			conn.Open();

			// Encrypted data gets decrypted after being returned by the query
			using (var cmd = new SqlCommand("SELECT * FROM Employee", conn))
			{
				using var rdr = cmd.ExecuteReader();
				while (rdr.Read())
				{
					Console.WriteLine("EmployeeId: {0}; Name: {1}; SSN: {2}; Salary: {3}; City: {4}",
						rdr["EmployeeId"], rdr["Name"], rdr["SSN"], rdr["Salary"], rdr["City"]);
				}
				rdr.Close();
			}
			Console.WriteLine();

			// Can't query on Salary, even with column encryption setting, because it uses randomized encryption
			using (var cmd = new SqlCommand("SELECT * FROM Employee WHERE Salary = @Salary", conn))
			{
				var parm = new SqlParameter("@Salary", SqlDbType.VarChar, 20) { Value = "Doug Nichols" };
				cmd.Parameters.Add(parm);

				try
				{
					cmd.ExecuteScalar();
				}
				catch (Exception ex)
				{
					Console.WriteLine("Failed to run query on Salary column");
					Console.WriteLine(ex.Message);
				}
			}
			Console.WriteLine();

			// Can query on SSN, because it uses deterministic encryption
			using (var cmd = new SqlCommand("SELECT * FROM Employee WHERE SSN IN (@SSN1, @SSN2)", conn))
			{
				var ssn1parm = new SqlParameter("@SSN1", SqlDbType.VarChar, 20) { Value = "987-65-4321" };
				cmd.Parameters.Add(ssn1parm);

				var ssn2parm = new SqlParameter("@SSN2", SqlDbType.VarChar, 20) { Value = "246-80-1357" };
				cmd.Parameters.Add(ssn2parm);

				using var rdr = cmd.ExecuteReader();
				while (rdr.Read())
				{
					Console.WriteLine("EmployeeId: {0}; Name: {1}; SSN: {2}; Salary: {3}; City: {4}",
						rdr["EmployeeId"], rdr["Name"], rdr["SSN"], rdr["Salary"], rdr["City"]);
				}
				rdr.Close();
			}
			Console.WriteLine();

			// Can never run a range query, even when using deterministic encryption
			using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Employee WHERE SSN >= @SSN", conn))
			{
				var parm = new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "500-000-0000" };
				cmd.Parameters.Add(parm);

				try
				{
					cmd.ExecuteScalar();
				}
				catch (Exception ex)
				{
					Console.WriteLine("Failed to run range query on SSN column");
					Console.WriteLine(ex.Message);
				}
			}
			Console.WriteLine();

			// Can insert encrypted data
			using (var cmd = new SqlCommand("INSERT INTO Employee VALUES(@Name, @SSN, @Salary, @City)", conn))
			{
				var nameParam = new SqlParameter("@Name", SqlDbType.VarChar, 20) { Value = "Steven Jacobs" };
				cmd.Parameters.Add(nameParam);

				var ssnParam = new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "333-22-4444" };
				cmd.Parameters.Add(ssnParam);

				var salaryParam = new SqlParameter("@Salary", SqlDbType.Money) { Value = 57006 };
				cmd.Parameters.Add(salaryParam);

				var cityParam = new SqlParameter("@City", SqlDbType.VarChar, 20) { Value = "Denver" };
				cmd.Parameters.Add(cityParam);

				cmd.ExecuteNonQuery();
				Console.WriteLine("Successfully inserted new row with encrypted data");
			}
			Console.WriteLine();

			conn.Close();
			Console.WriteLine();
		}

		private static void RunWithEncryptionSettingStoredProcs()
		{
			using var conn = new SqlConnection(AeEnabledConnStr);
			conn.Open();

			// Retrieve encrypted columns using stored procedure
			using (var cmd = conn.CreateCommand())
			{
				cmd.CommandText = "SelectEmployees";
				cmd.CommandType = CommandType.StoredProcedure;

				using var rdr = cmd.ExecuteReader();
				while (rdr.Read())
				{
					var employeeId = rdr["EmployeeId"];
					var name = rdr["Name"];
					var ssn = rdr["SSN"];
					var city = rdr["City"];

					Console.WriteLine("EmployeeId: {0}; Name: {1}; SSN: {2}; City: {3}",
						employeeId, name, ssn, city);
				}
				rdr.Close();
			}
			Console.WriteLine();

			// Select encrypted columns using stored procedure by query on deterministically encrypted column
			using (var cmd = conn.CreateCommand())
			{
				cmd.CommandText = "SelectEmployeesBySSN";
				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "246-80-1357" });

				using var rdr = cmd.ExecuteReader();
				while (rdr.Read())
				{
					var employeeId = rdr["EmployeeId"];
					var name = rdr["Name"];
					var ssn = rdr["SSN"];
					var city = rdr["City"];

					Console.WriteLine("EmployeeId: {0}; Name: {1}; SSN: {2}; City: {3}",
						employeeId, name, ssn, city);
				}
				rdr.Close();
			}
			Console.WriteLine();

			// Insert encrypted columns using stored procedure
			using (var cmd = conn.CreateCommand())
			{
				cmd.CommandText = "InsertEmployee";
				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@Name", SqlDbType.VarChar, 20) { Value = "Marcy Jones" });
				cmd.Parameters.Add(new SqlParameter("@SSN", SqlDbType.VarChar, 20) { Value = "888-88-8888" });
				cmd.Parameters.Add(new SqlParameter("@Salary", SqlDbType.Money) { Value = 45365 });
				cmd.Parameters.Add(new SqlParameter("@City", SqlDbType.VarChar, 20) { Value = "Atlanta" });

				cmd.ExecuteNonQuery();
				Console.WriteLine("Successfully created new employee");
			}
			Console.WriteLine();

			conn.Close();
			Console.WriteLine();
		}

	}
}
