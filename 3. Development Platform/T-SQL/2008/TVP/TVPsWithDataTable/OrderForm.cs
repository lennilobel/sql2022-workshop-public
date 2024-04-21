using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Windows.Forms;

namespace TVPsWithDataTable
{
	// Prep demo using "\3. Development Platform\T-SQL\2008\TVP.sql"

	public partial class OrderForm : Form
	{
		// https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/connect/certificate-chain-not-trusted?tabs=ole-db-driver-19
		private const string ConnectionString = "Data Source=.;Initial Catalog=MyDb;Integrated Security=True;Trust Server Certificate=True";

		public OrderForm()
		{
			InitializeComponent();
		}

		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad(e);

			this.OrderBindingSource.AddNew();
			this.DateTimePicker1.Value = DateTime.Now;
		}

		private void SaveOrderButton_Click(object sender, EventArgs e)
		{
			System.Diagnostics.Debugger.Break();

			this.OrderBindingSource.EndEdit();
			using var conn = new SqlConnection(ConnectionString);

			conn.Open();

			using var cmd = new SqlCommand("uspInsertNewOrder", conn);
			cmd.CommandType = CommandType.StoredProcedure;

			var headerParam = cmd.Parameters.AddWithValue("@OrderHeader", this.OrderDS1.Order);
			var detailsParam = cmd.Parameters.AddWithValue("@OrderDetails", this.OrderDS1.OrderDetail);

			headerParam.SqlDbType = SqlDbType.Structured;
			detailsParam.SqlDbType = SqlDbType.Structured;

			cmd.ExecuteNonQuery();

			conn.Close();
		}

	}
}
