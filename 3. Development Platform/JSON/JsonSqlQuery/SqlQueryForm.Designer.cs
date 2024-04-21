namespace JsonSqlQuery
{
    partial class SqlQueryForm
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(SqlQueryForm));
            this.MainSplitContainer = new System.Windows.Forms.SplitContainer();
            this.panel2 = new System.Windows.Forms.Panel();
            this.SqlTextBox = new ScintillaNET.Scintilla();
            this.panel1 = new System.Windows.Forms.Panel();
            this.BottomTabControl = new System.Windows.Forms.TabControl();
            this.MessagesTabPage = new System.Windows.Forms.TabPage();
            this.MessagesWebBrowser = new System.Windows.Forms.WebBrowser();
            this.ResultsTabPage = new System.Windows.Forms.TabPage();
            this.ResultsDataGridView = new System.Windows.Forms.DataGridView();
            this.ResultsListPanel = new System.Windows.Forms.Panel();
            this.ResultsListBox = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.ResultsToolStripStatusLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this.JsonTabPage = new System.Windows.Forms.TabPage();
            this.JsonTextBox = new ScintillaNET.Scintilla();
            this.toolStrip2 = new System.Windows.Forms.ToolStrip();
            this.toolStripLabel1 = new System.Windows.Forms.ToolStripLabel();
            this.DatabaseToolStripComboBox = new System.Windows.Forms.ToolStripComboBox();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.ExecuteToolStripButton = new System.Windows.Forms.ToolStripButton();
            ((System.ComponentModel.ISupportInitialize)(this.MainSplitContainer)).BeginInit();
            this.MainSplitContainer.Panel1.SuspendLayout();
            this.MainSplitContainer.Panel2.SuspendLayout();
            this.MainSplitContainer.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel1.SuspendLayout();
            this.BottomTabControl.SuspendLayout();
            this.MessagesTabPage.SuspendLayout();
            this.ResultsTabPage.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.ResultsDataGridView)).BeginInit();
            this.ResultsListPanel.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.JsonTabPage.SuspendLayout();
            this.toolStrip2.SuspendLayout();
            this.SuspendLayout();
            // 
            // MainSplitContainer
            // 
            this.MainSplitContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.MainSplitContainer.Location = new System.Drawing.Point(0, 25);
            this.MainSplitContainer.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MainSplitContainer.Name = "MainSplitContainer";
            this.MainSplitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // MainSplitContainer.Panel1
            // 
            this.MainSplitContainer.Panel1.Controls.Add(this.panel2);
            // 
            // MainSplitContainer.Panel2
            // 
            this.MainSplitContainer.Panel2.Controls.Add(this.panel1);
            this.MainSplitContainer.Size = new System.Drawing.Size(1008, 618);
            this.MainSplitContainer.SplitterDistance = 308;
            this.MainSplitContainer.TabIndex = 1;
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.White;
            this.panel2.Controls.Add(this.SqlTextBox);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Padding = new System.Windows.Forms.Padding(4);
            this.panel2.Size = new System.Drawing.Size(1008, 308);
            this.panel2.TabIndex = 4;
            // 
            // SqlTextBox
            // 
            this.SqlTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.SqlTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.SqlTextBox.Location = new System.Drawing.Point(4, 4);
            this.SqlTextBox.Name = "SqlTextBox";
            this.SqlTextBox.Size = new System.Drawing.Size(1000, 300);
            this.SqlTextBox.TabIndex = 0;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.Controls.Add(this.BottomTabControl);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Padding = new System.Windows.Forms.Padding(4);
            this.panel1.Size = new System.Drawing.Size(1008, 306);
            this.panel1.TabIndex = 5;
            // 
            // BottomTabControl
            // 
            this.BottomTabControl.Controls.Add(this.MessagesTabPage);
            this.BottomTabControl.Controls.Add(this.ResultsTabPage);
            this.BottomTabControl.Controls.Add(this.JsonTabPage);
            this.BottomTabControl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.BottomTabControl.Location = new System.Drawing.Point(4, 4);
            this.BottomTabControl.Name = "BottomTabControl";
            this.BottomTabControl.SelectedIndex = 0;
            this.BottomTabControl.Size = new System.Drawing.Size(1000, 298);
            this.BottomTabControl.TabIndex = 4;
            // 
            // MessagesTabPage
            // 
            this.MessagesTabPage.Controls.Add(this.MessagesWebBrowser);
            this.MessagesTabPage.Location = new System.Drawing.Point(4, 24);
            this.MessagesTabPage.Name = "MessagesTabPage";
            this.MessagesTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.MessagesTabPage.Size = new System.Drawing.Size(992, 270);
            this.MessagesTabPage.TabIndex = 0;
            this.MessagesTabPage.Text = "Messages";
            this.MessagesTabPage.UseVisualStyleBackColor = true;
            // 
            // MessagesWebBrowser
            // 
            this.MessagesWebBrowser.Dock = System.Windows.Forms.DockStyle.Fill;
            this.MessagesWebBrowser.Location = new System.Drawing.Point(3, 3);
            this.MessagesWebBrowser.MinimumSize = new System.Drawing.Size(20, 18);
            this.MessagesWebBrowser.Name = "MessagesWebBrowser";
            this.MessagesWebBrowser.Size = new System.Drawing.Size(986, 264);
            this.MessagesWebBrowser.TabIndex = 5;
            this.MessagesWebBrowser.PreviewKeyDown += new System.Windows.Forms.PreviewKeyDownEventHandler(this.WebBrowser_PreviewKeyDown);
            // 
            // ResultsTabPage
            // 
            this.ResultsTabPage.Controls.Add(this.ResultsDataGridView);
            this.ResultsTabPage.Controls.Add(this.ResultsListPanel);
            this.ResultsTabPage.Controls.Add(this.statusStrip1);
            this.ResultsTabPage.Location = new System.Drawing.Point(4, 24);
            this.ResultsTabPage.Name = "ResultsTabPage";
            this.ResultsTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.ResultsTabPage.Size = new System.Drawing.Size(992, 270);
            this.ResultsTabPage.TabIndex = 1;
            this.ResultsTabPage.Text = "Results";
            this.ResultsTabPage.UseVisualStyleBackColor = true;
            // 
            // ResultsDataGridView
            // 
            this.ResultsDataGridView.AllowUserToAddRows = false;
            this.ResultsDataGridView.AllowUserToDeleteRows = false;
            this.ResultsDataGridView.AllowUserToResizeRows = false;
            this.ResultsDataGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.ResultsDataGridView.BackgroundColor = System.Drawing.Color.White;
            this.ResultsDataGridView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ResultsDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.ResultsDataGridView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ResultsDataGridView.Location = new System.Drawing.Point(112, 3);
            this.ResultsDataGridView.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.ResultsDataGridView.Name = "ResultsDataGridView";
            this.ResultsDataGridView.ReadOnly = true;
            this.ResultsDataGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.ResultsDataGridView.Size = new System.Drawing.Size(877, 242);
            this.ResultsDataGridView.TabIndex = 5;
            this.ResultsDataGridView.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.ResultsDataGridView_CellDoubleClick);
            // 
            // ResultsListPanel
            // 
            this.ResultsListPanel.BackColor = System.Drawing.Color.Transparent;
            this.ResultsListPanel.Controls.Add(this.ResultsListBox);
            this.ResultsListPanel.Controls.Add(this.label1);
            this.ResultsListPanel.Controls.Add(this.label3);
            this.ResultsListPanel.Controls.Add(this.label2);
            this.ResultsListPanel.Dock = System.Windows.Forms.DockStyle.Left;
            this.ResultsListPanel.Location = new System.Drawing.Point(3, 3);
            this.ResultsListPanel.Name = "ResultsListPanel";
            this.ResultsListPanel.Padding = new System.Windows.Forms.Padding(0, 0, 4, 0);
            this.ResultsListPanel.Size = new System.Drawing.Size(109, 242);
            this.ResultsListPanel.TabIndex = 8;
            // 
            // ResultsListBox
            // 
            this.ResultsListBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ResultsListBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ResultsListBox.FormattingEnabled = true;
            this.ResultsListBox.ItemHeight = 15;
            this.ResultsListBox.Location = new System.Drawing.Point(0, 17);
            this.ResultsListBox.Name = "ResultsListBox";
            this.ResultsListBox.Size = new System.Drawing.Size(97, 225);
            this.ResultsListBox.TabIndex = 7;
            this.ResultsListBox.SelectedIndexChanged += new System.EventHandler(this.ResultsListBox_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.BackColor = System.Drawing.Color.LightGray;
            this.label1.Dock = System.Windows.Forms.DockStyle.Top;
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(97, 17);
            this.label1.TabIndex = 4;
            this.label1.Text = "Result Sets";
            // 
            // label3
            // 
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Dock = System.Windows.Forms.DockStyle.Right;
            this.label3.Location = new System.Drawing.Point(97, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(4, 242);
            this.label3.TabIndex = 9;
            // 
            // label2
            // 
            this.label2.BackColor = System.Drawing.Color.Gray;
            this.label2.Dock = System.Windows.Forms.DockStyle.Right;
            this.label2.Location = new System.Drawing.Point(101, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(4, 242);
            this.label2.TabIndex = 8;
            // 
            // statusStrip1
            // 
            this.statusStrip1.ImageScalingSize = new System.Drawing.Size(32, 32);
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ResultsToolStripStatusLabel});
            this.statusStrip1.Location = new System.Drawing.Point(3, 245);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(986, 22);
            this.statusStrip1.TabIndex = 6;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // ResultsToolStripStatusLabel
            // 
            this.ResultsToolStripStatusLabel.Name = "ResultsToolStripStatusLabel";
            this.ResultsToolStripStatusLabel.Size = new System.Drawing.Size(118, 17);
            this.ResultsToolStripStatusLabel.Text = "toolStripStatusLabel1";
            // 
            // JsonTabPage
            // 
            this.JsonTabPage.Controls.Add(this.JsonTextBox);
            this.JsonTabPage.Location = new System.Drawing.Point(4, 24);
            this.JsonTabPage.Name = "JsonTabPage";
            this.JsonTabPage.Padding = new System.Windows.Forms.Padding(3);
            this.JsonTabPage.Size = new System.Drawing.Size(992, 270);
            this.JsonTabPage.TabIndex = 2;
            this.JsonTabPage.Text = "JSON";
            this.JsonTabPage.UseVisualStyleBackColor = true;
            // 
            // JsonTextBox
            // 
            this.JsonTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.JsonTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.JsonTextBox.Location = new System.Drawing.Point(3, 3);
            this.JsonTextBox.Name = "JsonTextBox";
            this.JsonTextBox.ReadOnly = true;
            this.JsonTextBox.Size = new System.Drawing.Size(986, 264);
            this.JsonTextBox.TabIndex = 1;
            // 
            // toolStrip2
            // 
            this.toolStrip2.Font = new System.Drawing.Font("Roboto", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.toolStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
            this.toolStrip2.ImageScalingSize = new System.Drawing.Size(32, 32);
            this.toolStrip2.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripLabel1,
            this.DatabaseToolStripComboBox,
            this.toolStripSeparator1,
            this.ExecuteToolStripButton});
            this.toolStrip2.Location = new System.Drawing.Point(0, 0);
            this.toolStrip2.Name = "toolStrip2";
            this.toolStrip2.Size = new System.Drawing.Size(1008, 25);
            this.toolStrip2.TabIndex = 3;
            this.toolStrip2.Text = "toolStrip2";
            // 
            // toolStripLabel1
            // 
            this.toolStripLabel1.Name = "toolStripLabel1";
            this.toolStripLabel1.Size = new System.Drawing.Size(59, 22);
            this.toolStripLabel1.Text = "Database";
            // 
            // DatabaseToolStripComboBox
            // 
            this.DatabaseToolStripComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.DatabaseToolStripComboBox.Font = new System.Drawing.Font("Roboto", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DatabaseToolStripComboBox.Name = "DatabaseToolStripComboBox";
            this.DatabaseToolStripComboBox.Size = new System.Drawing.Size(200, 25);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // ExecuteToolStripButton
            // 
            this.ExecuteToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ExecuteToolStripButton.Image = ((System.Drawing.Image)(resources.GetObject("ExecuteToolStripButton.Image")));
            this.ExecuteToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.ExecuteToolStripButton.Name = "ExecuteToolStripButton";
            this.ExecuteToolStripButton.Size = new System.Drawing.Size(82, 22);
            this.ExecuteToolStripButton.Text = "Execute (F5)";
            this.ExecuteToolStripButton.Click += new System.EventHandler(this.ExecuteToolStripButton_Click);
            // 
            // SqlQueryForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Gray;
            this.ClientSize = new System.Drawing.Size(1008, 643);
            this.Controls.Add(this.MainSplitContainer);
            this.Controls.Add(this.toolStrip2);
            this.Font = new System.Drawing.Font("Roboto", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.Name = "SqlQueryForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "SQL Query";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.MainSplitContainer.Panel1.ResumeLayout(false);
            this.MainSplitContainer.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.MainSplitContainer)).EndInit();
            this.MainSplitContainer.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.BottomTabControl.ResumeLayout(false);
            this.MessagesTabPage.ResumeLayout(false);
            this.ResultsTabPage.ResumeLayout(false);
            this.ResultsTabPage.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.ResultsDataGridView)).EndInit();
            this.ResultsListPanel.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.JsonTabPage.ResumeLayout(false);
            this.toolStrip2.ResumeLayout(false);
            this.toolStrip2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion
		private System.Windows.Forms.SplitContainer MainSplitContainer;
		private System.Windows.Forms.ToolStrip toolStrip2;
		private System.Windows.Forms.ToolStripButton ExecuteToolStripButton;
		private System.Windows.Forms.TabControl BottomTabControl;
		private System.Windows.Forms.TabPage MessagesTabPage;
		private System.Windows.Forms.TabPage ResultsTabPage;
		private System.Windows.Forms.DataGridView ResultsDataGridView;
		private System.Windows.Forms.TabPage JsonTabPage;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Panel panel2;
		private System.Windows.Forms.StatusStrip statusStrip1;
		private System.Windows.Forms.ToolStripStatusLabel ResultsToolStripStatusLabel;
		private System.Windows.Forms.WebBrowser MessagesWebBrowser;
		private System.Windows.Forms.ListBox ResultsListBox;
		private System.Windows.Forms.Panel ResultsListPanel;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private ScintillaNET.Scintilla SqlTextBox;
		private System.Windows.Forms.ToolStripComboBox DatabaseToolStripComboBox;
		private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
		private System.Windows.Forms.ToolStripLabel toolStripLabel1;
		private ScintillaNET.Scintilla JsonTextBox;
	}
}
