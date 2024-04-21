using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Transactions;

namespace PhotoLibraryWeb
{
	public class PhotoData
	{
		public static void InsertPhoto(int photoId, string desc, Stream source)
		{
			var connStr = ConfigurationManager.ConnectionStrings["PhotoLibraryDb"].ConnectionString;
			using (var conn = new SqlConnection(connStr))
			{
				using (var cmd = new SqlCommand("InsertPhotoRow", conn))
				{
					using (var ts = new TransactionScope())
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.AddWithValue("@PhotoId", photoId);
						cmd.Parameters.AddWithValue("@PhotoDescription", desc);

						var serverPathName = default(string);
						var serverTxnContext = default(byte[]);

						conn.Open();
						using (var rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							serverPathName = rdr.GetSqlString(0).Value;
							serverTxnContext = rdr.GetSqlBinary(1).Value;
							rdr.Close();
						}
						conn.Close();

						using (var dest = new SqlFileStream(serverPathName, serverTxnContext, FileAccess.Write))
						{
							source.CopyTo(dest, 4096);
							dest.Close();
						}

						ts.Complete();
					}

				}

			}
		}

		public static byte[] SelectPhotoImage(int photoId)
		{
			var photoImage = default(byte[]);

			using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["PhotoLibraryDb"].ConnectionString))
			{
				using (var cmd = new SqlCommand("SelectPhotoImageInfo", conn))
				{
					using (var ts = new TransactionScope())
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.AddWithValue("@PhotoId", photoId);

						var serverPathName = default(string);
						var serverTxnContext = default(byte[]);

						conn.Open();
						using (var rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							serverPathName = rdr.GetSqlString(0).Value;
							serverTxnContext = rdr.GetSqlBinary(1).Value;
							rdr.Close();
						}
						conn.Close();

						using (var source = new SqlFileStream(serverPathName, serverTxnContext, FileAccess.Read))
						{
							using (var dest = new MemoryStream())
							{
								source.CopyTo(dest, 4096);
								dest.Close();
								photoImage = dest.ToArray();
							}
							source.Close();
						}

						ts.Complete();
					}
				}
			}

			return photoImage;
		}

		public static string SelectPhotoDescription(int photoId)
		{
			var desc = default(string);

			var connStr = ConfigurationManager.ConnectionStrings["PhotoLibraryDb"].ConnectionString;
			using (var conn = new SqlConnection(connStr))
			{
				conn.Open();

				using (var cmd = new SqlCommand("SelectPhotoDescription", conn))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@PhotoId", photoId);
					cmd.Parameters.Add("@PhotoDescription", SqlDbType.VarChar, -1);
					cmd.Parameters["@PhotoDescription"].Direction = ParameterDirection.Output;

					cmd.ExecuteNonQuery();
					desc = cmd.Parameters["@PhotoDescription"].Value.ToString();
				}
			}

			return desc;
		}

	}
}
