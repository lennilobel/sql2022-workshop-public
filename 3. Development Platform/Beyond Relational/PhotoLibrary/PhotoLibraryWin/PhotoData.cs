using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Transactions;

namespace PhotoLibraryWin
{
	public static class PhotoData
	{
		private const string ConnStr =
		  "Data Source=.;Integrated Security=True;Initial Catalog=PhotoLibrary;";

		public static void InsertPhoto(int photoId, string desc, string sourceFilename)
		{
			const string TSql = @"
				INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
					OUTPUT inserted.Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
					SELECT @PhotoId, @PhotoDescription, 0x";

			using (var conn = new SqlConnection(ConnStr))
			{
				using (var cmd = new SqlCommand(TSql, conn))
				{
					using (var ts = new TransactionScope(TransactionScopeOption.Required, new TimeSpan(0, 5, 0)))
					{
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

						using (var source = new FileStream(sourceFilename, FileMode.Open, FileAccess.Read))
						{
							using (var dest = new SqlFileStream(serverPathName, serverTxnContext, FileAccess.Write))
							{
								source.CopyTo(dest, 4096);
								dest.Close();
							}
							source.Close();
						}

						ts.Complete();
					}
				}
			}

		}

		public static PhotoContent SelectPhoto(int photoId)
		{
			var photoContent = new PhotoContent();

			const string TSql = @"
				SELECT PhotoDescription, Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
					FROM PhotoAlbum
					WHERE PhotoId = @PhotoId";

			using (var conn = new SqlConnection(ConnStr))
			{
				using (var cmd = new SqlCommand(TSql, conn))
				{
					using (var ts = new TransactionScope(TransactionScopeOption.Required, new TimeSpan(0, 5, 0)))
					{
						cmd.Parameters.AddWithValue("@PhotoId", photoId);

						var serverPathName = default(string);		// string to hold the BLOB pathname
						var serverTxnContext = default(byte[]);	// byte array to hold the txn context

						conn.Open();
						using (var rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							photoContent.Description = rdr.GetSqlString(0).Value;
							serverPathName = rdr.GetSqlString(1).Value;
							serverTxnContext = rdr.GetSqlBinary(2).Value;
							rdr.Close();
						}
						conn.Close();

						using (var source = new SqlFileStream(serverPathName, serverTxnContext, FileAccess.Read))
						{
							using (var dest = new MemoryStream())
							{
								source.CopyTo(dest, 4096);
								dest.Close();
								photoContent.Photo = dest.ToArray();
							}
							source.Close();
						}

						ts.Complete();
					}
				}
			}

			return photoContent;
		}

	}

}
