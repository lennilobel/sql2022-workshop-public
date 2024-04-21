using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using System.Transactions;
using System.Data.SqlTypes;

namespace EventMediaSpatialApp
{
	public partial class PhotoSearchForm : Form
	{
		private const string ConnStr =
				"Data Source=.;Integrated Security=True;Initial Catalog=EventLibrary;";

		public PhotoSearchForm()
		{
			InitializeComponent();
		}

		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad(e);

			this.LoadRegions();
		}

		private void lnkAddPhotos_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			this.AddPhotos();
		}

		private void lnkSearch_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			this.FindRegionPhotos();
		}

		private void lstPhotos_SelectedIndexChanged(object sender, EventArgs e)
		{
			this.DisplayPhoto();
		}

		private void LoadRegions()
		{
			using (SqlDataAdapter adp = new SqlDataAdapter("GetRegions", ConnStr))
			{
				adp.SelectCommand.CommandType = CommandType.StoredProcedure;
				DataSet ds = new DataSet();
				adp.Fill(ds);
				this.cboRegions.DataSource = ds.Tables[0];
				this.cboRegions.ValueMember = "RegionId";
				this.cboRegions.DisplayMember = "RegionName";
			}
		}

		private void FindRegionPhotos()
		{
			this.lstPhotos.SelectedIndexChanged -= new System.EventHandler(this.lstPhotos_SelectedIndexChanged);

			int regionId = (int)this.cboRegions.SelectedValue;

			using (SqlDataAdapter adp = new SqlDataAdapter("GetRegionPhotos", ConnStr))
			{
				adp.SelectCommand.CommandType = CommandType.StoredProcedure;
				adp.SelectCommand.Parameters.AddWithValue("@RegionId", regionId);
				DataSet ds = new DataSet();
				adp.Fill(ds);
				this.lstPhotos.DataSource = ds.Tables[0];
				this.lstPhotos.ValueMember = "PhotoId";
				this.lstPhotos.DisplayMember = "Description";
			}
			this.lstPhotos.SelectedIndexChanged += new System.EventHandler(this.lstPhotos_SelectedIndexChanged);
			this.DisplayPhoto();
		}

		private void DisplayPhoto()
		{
			int photoId = (int)this.lstPhotos.SelectedValue;
			this.picImage.Image = this.GetPhoto(photoId);
		}

		private Image GetPhoto(int photoId)
		{
			Image photo;
			using (TransactionScope ts = new TransactionScope())
			{
				using (SqlConnection conn = new SqlConnection(ConnStr))
				{
					conn.Open();

					string filePath;
					byte[] txnToken;

					using (SqlCommand cmd = new SqlCommand("GetPhotoForFilestream", conn))
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.Add("@PhotoId", SqlDbType.Int).Value = photoId;

						using (SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							filePath = rdr.GetSqlString(0).Value;
							txnToken = rdr.GetSqlBinary(1).Value;
							rdr.Close();
						}
					}

					photo = this.LoadPhotoImage(filePath, txnToken);
				}
				ts.Complete();
			}

			return photo;
		}

		private Image LoadPhotoImage(string filePath, byte[] txnToken)
		{
			Image photo;

			using (SqlFileStream sfs = new SqlFileStream(filePath, txnToken, FileAccess.Read))
			{
				photo = Image.FromStream(sfs);
				sfs.Close();
			}

			return photo;
		}

		private void AddPhotos()
		{
			this.InsertEventPhoto(1, "Taken from the Ben Franklin parkway near the finish line", -75.17396, 39.96045, "bike9_2.jpg");
			this.InsertEventPhoto(2, "This shot was taken from the bottom of the Manayunk Wall", -75.22457, 40.02593, "wall_race_2.jpg");
			this.InsertEventPhoto(3, "This shot was taken at the top of the Manayunk Wall.", -75.21986, 40.02920, "wall_race2_2.jpg");
			this.InsertEventPhoto(4, "This is another shot from the Benjamin Franklin Parkway.", -75.17052, 39.95813, "parkway_area2_2.jpg");

			MessageBox.Show("Added 4 photos to database");
		}

		private void InsertEventPhoto(
		 int photoId,
		 string desc,
		 double longitude,
		 double latitude,
		 string photoFile)
		{
			const string InsertTSql = @"
			  INSERT INTO EventPhoto(PhotoId, Description, Location)
			   VALUES(@PhotoId, @Description, geography::Parse(@Location))

			  SELECT Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
			   FROM EventPhoto
			   WHERE PhotoId = @PhotoId";

			const string PointMask = "POINT ({0} {1})";
			string location = string.Format(PointMask, longitude, latitude);

			string serverPath;
			byte[] serverTxn;

			using (TransactionScope ts = new TransactionScope())
			{
				using (SqlConnection conn = new SqlConnection(ConnStr))
				{
					conn.Open();

					using (SqlCommand cmd = new SqlCommand(InsertTSql, conn))
					{
						cmd.Parameters.Add("@PhotoId", SqlDbType.Int).Value = photoId;
						cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = desc;
						cmd.Parameters.Add("@Location", SqlDbType.NVarChar).Value = location;
						using (SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							serverPath = rdr.GetSqlString(0).Value;
							serverTxn = rdr.GetSqlBinary(1).Value;
							rdr.Close();
						}
					}
					this.SavePhotoFile(photoFile, serverPath, serverTxn);
				}
				ts.Complete();
			}
		}

		private void SavePhotoFile
		  (string photoFile, string serverPath, byte[] serverTxn)
		{
			const string LocalPath = @"..\..\Photos\";
			const int BlockSize = 1024 * 512;

			using (FileStream source =
			  new FileStream(LocalPath + photoFile, FileMode.Open, FileAccess.Read))
			{
				using (SqlFileStream dest =
				  new SqlFileStream(serverPath, serverTxn, FileAccess.Write))
				{
					byte[] buffer = new byte[BlockSize];
					int bytesRead;
					while ((bytesRead = source.Read(buffer, 0, buffer.Length)) > 0)
					{
						dest.Write(buffer, 0, bytesRead);
						dest.Flush();
					}
					dest.Close();
				}
				source.Close();
			}
		}

	}
}
