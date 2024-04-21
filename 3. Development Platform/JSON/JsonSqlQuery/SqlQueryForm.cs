using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace JsonSqlQuery
{
    public partial class SqlQueryForm : Form
	{
		private IDictionary<string, string> _connectionStrings;

		public SqlQueryForm()
		{
			InitializeComponent();
		}

        #region "UI"

        protected override void OnLoad(EventArgs e)
		{
			base.OnLoad(e);

			this.SqlTextBox.ConfigureScintillaForSql();
			this.JsonTextBox.ConfigureScintillaForJson();
			this.LoadConnectionStrings();
		}

		internal void Launch(string sql)
		{
			this.Show();
			this.BringToFront();
			this.SqlTextBox.Text = sql;
			this.ShowHideResultsGrid(false);
		}

		protected override void OnKeyUp(KeyEventArgs e)
		{
			base.OnKeyUp(e);

			if (e.KeyCode == Keys.F5 && e.Modifiers == Keys.None)
			{
				this.Execute();
				e.Handled = true;
			}
		}

		protected override void OnKeyPress(KeyPressEventArgs e)
		{
			base.OnKeyPress(e);

			// CTRL+R
			if (e.KeyChar == (char)18)
			{
				this.ShowHideResultsGrid(this.MainSplitContainer.Panel2Collapsed);
				e.Handled = true;
			}

			// CTRL+A
			if (e.KeyChar == (char)1)
			{
				this.SqlTextBox.SelectAll();
				e.Handled = true;
			}
		}

		private DateTime? _previousWebBrowserCtrlR;

		private void WebBrowser_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
		{
			// CTRL+R
			if (e.KeyData == (Keys.Control | Keys.R))
			{
				var skip = this._previousWebBrowserCtrlR != null && DateTime.Now.Subtract(this._previousWebBrowserCtrlR.Value).TotalSeconds < 1;
				if (skip)
				{
					return;
				}
				this.ShowHideResultsGrid(this.MainSplitContainer.Panel2Collapsed);
				this._previousWebBrowserCtrlR = DateTime.Now;
			}

		}

		private void ExecuteToolStripButton_Click(object sender, EventArgs e)
		{
			this.Execute();
		}

		private void ResultsDataGridView_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				var value = this.ResultsDataGridView.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString().TrimStart();
				if (value.StartsWith("[") || value.StartsWith("{"))
				{
                    this.SetJsonText(value);
					this.BottomTabControl.SelectedTab = this.JsonTabPage;
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void ShowHideResultsGrid(bool show)
		{
			this.MainSplitContainer.Panel2Collapsed = !show;
		}

		#endregion

		#region "Execute"

		private void LoadConnectionStrings()
		{
			this._connectionStrings = new Dictionary<string, string>();
			this.DatabaseToolStripComboBox.Items.Clear();
			foreach (var key in GlobalConfig.ConnectionStrings.Keys)
			{
				this._connectionStrings.Add(key, GlobalConfig.ConnectionStrings[key]);
				this.DatabaseToolStripComboBox.Items.Add(key);
				if (key.ToUpper() == "MASTER")
				{
					this.DatabaseToolStripComboBox.SelectedItem = key;
				}
			}
		}

		private void Execute()
		{
			try
			{
				var sql = this.SqlTextBox.SelectedText;
				if (string.IsNullOrWhiteSpace(sql))
				{
					sql = this.SqlTextBox.Text;
				}

				this.Execute(sql);

				this.SqlTextBox.Focus();
			}
			catch (Exception ex)
			{
				this.SetMessages($"<span style=color:red>{ex.Message}</span>");
				this.BottomTabControl.SelectedTab = this.MessagesTabPage;
			}
			finally
			{
				this.ShowHideResultsGrid(true);
			}
		}

		private DataSet _results;

		private void Execute(string sql)
		{
			this._results = this.RunSql(sql);

			this.ResultsListBox.Items.Clear();
			this.ResultsListPanel.Visible = false;

			var resultSetCount = this._results.Tables.Count;
			if (resultSetCount == 0)
			{
				this.BottomTabControl.SelectedTab = this.MessagesTabPage;
				this.SetMessages($"Query returned no data");
			}
			else
			{
				var sb = new StringBuilder();
				sb.Append($"Query returned {resultSetCount} result set(s)");
				this.ResultsListPanel.Visible = resultSetCount > 1;
				for (var i = 0; i < resultSetCount; i++)
				{
					var rowCount = this._results.Tables[i].Rows.Count;
					sb.Append($"<br />&nbsp;Result set # {i + 1}: {rowCount} row(s)");
					var rowsS = rowCount == 1 ? string.Empty : "s";
					this.ResultsListBox.Items.Add($"#{i + 1} ({rowCount} row{rowsS})");
				}
				this.ResultsListBox.SelectedIndex = 0;
				this.SetMessages(sb.ToString());
			}
		}

		private DataSet RunSql(string sql)
		{
			var sqlBatches = new List<string>();
			var lines = sql.Split(new[] { Environment.NewLine }, StringSplitOptions.None);

			var sb = new StringBuilder();
			foreach (var line in lines)
			{
				if (line.Trim().ToUpper() == "GO")
				{
					sqlBatches.Add(sb.ToString());
					sb = new StringBuilder();
					continue;
				}
				sb.Append(line + Environment.NewLine);
			}
			sqlBatches.Add(sb.ToString());

			var ds = new DataSet();
			for (var sqlBatchIndex = 0; sqlBatchIndex < sqlBatches.Count; sqlBatchIndex++)
			{
				var sqlBatch = sqlBatches[sqlBatchIndex];
				if (sqlBatch.Trim().Length == 0)
				{
					continue;
				}
				if (this.UseDatabaseSwitch(sqlBatch))
				{
					continue;
				}
				var connStr = this._connectionStrings[this.DatabaseToolStripComboBox.Text];
				using (var conn = new SqlConnection(connStr))
				{
					conn.Open();
					using (var cmd = new SqlCommand(sqlBatch, conn))
					{
						using (var adp = new SqlDataAdapter(cmd))
						{
							var batchDs = new DataSet();
							adp.Fill(batchDs);
							for (var tableIndex = 0; tableIndex < batchDs.Tables.Count; tableIndex++)
							{
								batchDs.Tables[tableIndex].TableName = $"Batch{sqlBatchIndex}_Table{tableIndex}";
							}
							ds.Merge(batchDs);
						}
					}
				}
			}
			return ds;
		}

		private bool UseDatabaseSwitch(string sqlBatch)
		{
			var statement = string.Join(Environment.NewLine, sqlBatch.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries).Where(l => !l.StartsWith("/*") && !l.StartsWith("--"))).ToUpper();
			if (statement.StartsWith("USE "))
			{
				var parts = statement.Split(' ');
				if (parts.Length > 1)
				{
					var databaseName = parts[1];
					if (this._connectionStrings.Keys.Select(k => k.ToUpper()).Contains(databaseName))
					{
						foreach (string item in this.DatabaseToolStripComboBox.Items)
						{
							if (item.ToUpper() == databaseName)
							{
								this.DatabaseToolStripComboBox.SelectedItem = item;
								return true;
							}
						}
						return true;
					}
				}
			}
			return false;
		}

		private void SetMessages(string messages)
		{
			this.MessagesWebBrowser.DocumentText = $"<span style=font-family:'roboto,consolas'><span style=color:blue>{DateTime.Now}</span><br />{messages}</span>";
		}

		private void ResultsListBox_SelectedIndexChanged(object sender, EventArgs e)
		{
			var dt = this._results.Tables[this.ResultsListBox.SelectedIndex];

			this.ResultsDataGridView.DataSource = dt;
			this.ResultsToolStripStatusLabel.Text = $"{dt.Rows.Count} row(s)";

			var scalar = dt.Rows.Count == 0 ? null : dt.Rows[0][0].ToString();
			if (dt.Columns.Count == 1 && (scalar.StartsWith("{") || scalar.StartsWith("[")))
			{
				for (var i = 1; i < dt.Rows.Count; i++)
				{
					scalar += dt.Rows[i][0].ToString();
				}
                this.SetJsonText(scalar);
				this.BottomTabControl.SelectedTab = this.JsonTabPage;
			}
			else
			{
				this.JsonTextBox.Text = "Non-JSON result";
				this.BottomTabControl.SelectedTab = this.ResultsTabPage;
			}
		}

        private void SetJsonText(string json)
        {
            var formattedJson = this.FormatJson(json);
            this.JsonTextBox.ReadOnly = false;
            this.JsonTextBox.Text = formattedJson;
            this.JsonTextBox.ReadOnly = true;
        }

        private string FormatJson(string unformattedJson)
		{
			const string Indent = "  ";

			unformattedJson = unformattedJson
				.Replace(Environment.NewLine, " ")
				.Replace("<", "&lt;")
				.Replace(">", "&gt;")
			;

			var level = 0;
			var quoteCount = 0;
			var result =
				from ch in unformattedJson
				let quotes = ch == '"' ? quoteCount++ : quoteCount
				let lineBreak = ch == ',' && quotes % 2 == 0 ? ch + Environment.NewLine + string.Concat(Enumerable.Repeat(Indent, level)) : null
				let openChar = ch == '{' || ch == '[' ? ch + Environment.NewLine + string.Concat(Enumerable.Repeat(Indent, ++level)) : ch.ToString()
				let closeChar = ch == '}' || ch == ']' ? Environment.NewLine + string.Concat(Enumerable.Repeat(Indent, --level)) + ch : ch.ToString()
				select lineBreak ?? (openChar.Length > 1 ? openChar : closeChar)
			;

			var json = string.Concat(result);
			return json;
		}

		#endregion

	}
}
