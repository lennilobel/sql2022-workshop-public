namespace TVPsWithDataTable
{
  partial class OrderForm
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
			this.components = new System.ComponentModel.Container();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle9 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle10 = new System.Windows.Forms.DataGridViewCellStyle();
			this.OrderDS1 = new TVPsWithDataTable.OrderDS();
			this.OrderDetailBindingSource = new System.Windows.Forms.BindingSource(this.components);
			this.OrderBindingSource = new System.Windows.Forms.BindingSource(this.components);
			this.Label4 = new System.Windows.Forms.Label();
			this.DataGridView1 = new System.Windows.Forms.DataGridView();
			this.OrderIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.LineNumberDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.ProductIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.QuantityDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.PriceDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.SaveOrderButton = new System.Windows.Forms.Button();
			this.TextBox2 = new System.Windows.Forms.TextBox();
			this.DateTimePicker1 = new System.Windows.Forms.DateTimePicker();
			this.TextBox1 = new System.Windows.Forms.TextBox();
			this.Label3 = new System.Windows.Forms.Label();
			this.Label2 = new System.Windows.Forms.Label();
			this.Label1 = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.OrderDS1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.OrderDetailBindingSource)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.OrderBindingSource)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).BeginInit();
			this.SuspendLayout();
			// 
			// OrderDS1
			// 
			this.OrderDS1.DataSetName = "OrderDS";
			this.OrderDS1.Namespace = "http://tempuri.org/OrderDS.xsd";
			this.OrderDS1.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
			// 
			// OrderDetailBindingSource
			// 
			this.OrderDetailBindingSource.DataMember = "OrderDetail";
			this.OrderDetailBindingSource.DataSource = this.OrderDS1;
			// 
			// OrderBindingSource
			// 
			this.OrderBindingSource.DataMember = "Order";
			this.OrderBindingSource.DataSource = this.OrderDS1;
			// 
			// Label4
			// 
			this.Label4.AutoSize = true;
			this.Label4.Location = new System.Drawing.Point(18, 132);
			this.Label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.Label4.Name = "Label4";
			this.Label4.Size = new System.Drawing.Size(60, 21);
			this.Label4.TabIndex = 15;
			this.Label4.Text = "Details:";
			// 
			// DataGridView1
			// 
			this.DataGridView1.AutoGenerateColumns = false;
			this.DataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
			this.DataGridView1.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
			this.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.DataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.OrderIdDataGridViewTextBoxColumn,
            this.LineNumberDataGridViewTextBoxColumn,
            this.ProductIdDataGridViewTextBoxColumn,
            this.QuantityDataGridViewTextBoxColumn,
            this.PriceDataGridViewTextBoxColumn});
			this.DataGridView1.DataSource = this.OrderDetailBindingSource;
			this.DataGridView1.Location = new System.Drawing.Point(18, 156);
			this.DataGridView1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.DataGridView1.Name = "DataGridView1";
			this.DataGridView1.RowTemplate.DefaultCellStyle.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.DataGridView1.Size = new System.Drawing.Size(658, 236);
			this.DataGridView1.TabIndex = 16;
			// 
			// OrderIdDataGridViewTextBoxColumn
			// 
			this.OrderIdDataGridViewTextBoxColumn.DataPropertyName = "OrderId";
			dataGridViewCellStyle6.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.OrderIdDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle6;
			this.OrderIdDataGridViewTextBoxColumn.HeaderText = "OrderId";
			this.OrderIdDataGridViewTextBoxColumn.Name = "OrderIdDataGridViewTextBoxColumn";
			this.OrderIdDataGridViewTextBoxColumn.Width = 89;
			// 
			// LineNumberDataGridViewTextBoxColumn
			// 
			this.LineNumberDataGridViewTextBoxColumn.DataPropertyName = "LineNumber";
			dataGridViewCellStyle7.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.LineNumberDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle7;
			this.LineNumberDataGridViewTextBoxColumn.HeaderText = "LineNumber";
			this.LineNumberDataGridViewTextBoxColumn.Name = "LineNumberDataGridViewTextBoxColumn";
			this.LineNumberDataGridViewTextBoxColumn.Width = 122;
			// 
			// ProductIdDataGridViewTextBoxColumn
			// 
			this.ProductIdDataGridViewTextBoxColumn.DataPropertyName = "ProductId";
			dataGridViewCellStyle8.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.ProductIdDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle8;
			this.ProductIdDataGridViewTextBoxColumn.HeaderText = "ProductId";
			this.ProductIdDataGridViewTextBoxColumn.Name = "ProductIdDataGridViewTextBoxColumn";
			this.ProductIdDataGridViewTextBoxColumn.Width = 102;
			// 
			// QuantityDataGridViewTextBoxColumn
			// 
			this.QuantityDataGridViewTextBoxColumn.DataPropertyName = "Quantity";
			dataGridViewCellStyle9.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.QuantityDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle9;
			this.QuantityDataGridViewTextBoxColumn.HeaderText = "Quantity";
			this.QuantityDataGridViewTextBoxColumn.Name = "QuantityDataGridViewTextBoxColumn";
			this.QuantityDataGridViewTextBoxColumn.Width = 95;
			// 
			// PriceDataGridViewTextBoxColumn
			// 
			this.PriceDataGridViewTextBoxColumn.DataPropertyName = "Price";
			dataGridViewCellStyle10.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.PriceDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle10;
			this.PriceDataGridViewTextBoxColumn.HeaderText = "Price";
			this.PriceDataGridViewTextBoxColumn.Name = "PriceDataGridViewTextBoxColumn";
			this.PriceDataGridViewTextBoxColumn.Width = 69;
			// 
			// SaveOrderButton
			// 
			this.SaveOrderButton.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.SaveOrderButton.Location = new System.Drawing.Point(564, 12);
			this.SaveOrderButton.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.SaveOrderButton.Name = "SaveOrderButton";
			this.SaveOrderButton.Size = new System.Drawing.Size(120, 39);
			this.SaveOrderButton.TabIndex = 17;
			this.SaveOrderButton.Text = "Save Order";
			this.SaveOrderButton.UseVisualStyleBackColor = true;
			this.SaveOrderButton.Click += new System.EventHandler(this.SaveOrderButton_Click);
			// 
			// TextBox2
			// 
			this.TextBox2.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.OrderBindingSource, "CustomerId", true));
			this.TextBox2.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.TextBox2.Location = new System.Drawing.Point(132, 52);
			this.TextBox2.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.TextBox2.Name = "TextBox2";
			this.TextBox2.Size = new System.Drawing.Size(148, 29);
			this.TextBox2.TabIndex = 12;
			// 
			// DateTimePicker1
			// 
			this.DateTimePicker1.DataBindings.Add(new System.Windows.Forms.Binding("Value", this.OrderBindingSource, "OrderedAt", true));
			this.DateTimePicker1.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.DateTimePicker1.Location = new System.Drawing.Point(132, 88);
			this.DateTimePicker1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.DateTimePicker1.Name = "DateTimePicker1";
			this.DateTimePicker1.Size = new System.Drawing.Size(430, 29);
			this.DateTimePicker1.TabIndex = 14;
			// 
			// TextBox1
			// 
			this.TextBox1.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.OrderBindingSource, "OrderId", true));
			this.TextBox1.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.TextBox1.Location = new System.Drawing.Point(132, 15);
			this.TextBox1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.TextBox1.Name = "TextBox1";
			this.TextBox1.Size = new System.Drawing.Size(148, 29);
			this.TextBox1.TabIndex = 10;
			// 
			// Label3
			// 
			this.Label3.AutoSize = true;
			this.Label3.Location = new System.Drawing.Point(18, 94);
			this.Label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.Label3.Name = "Label3";
			this.Label3.Size = new System.Drawing.Size(90, 21);
			this.Label3.TabIndex = 13;
			this.Label3.Text = "Ordered At:";
			// 
			// Label2
			// 
			this.Label2.AutoSize = true;
			this.Label2.Location = new System.Drawing.Point(18, 58);
			this.Label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.Label2.Name = "Label2";
			this.Label2.Size = new System.Drawing.Size(100, 21);
			this.Label2.TabIndex = 11;
			this.Label2.Text = "Customer ID:";
			// 
			// Label1
			// 
			this.Label1.AutoSize = true;
			this.Label1.Location = new System.Drawing.Point(18, 21);
			this.Label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.Label1.Name = "Label1";
			this.Label1.Size = new System.Drawing.Size(73, 21);
			this.Label1.TabIndex = 9;
			this.Label1.Text = "Order ID:";
			// 
			// OrderForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
			this.ClientSize = new System.Drawing.Size(694, 412);
			this.Controls.Add(this.Label4);
			this.Controls.Add(this.DataGridView1);
			this.Controls.Add(this.SaveOrderButton);
			this.Controls.Add(this.TextBox2);
			this.Controls.Add(this.DateTimePicker1);
			this.Controls.Add(this.TextBox1);
			this.Controls.Add(this.Label3);
			this.Controls.Add(this.Label2);
			this.Controls.Add(this.Label1);
			this.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
			this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.Name = "OrderForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Order Entry Using Table-Valued Parameters";
			((System.ComponentModel.ISupportInitialize)(this.OrderDS1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.OrderDetailBindingSource)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.OrderBindingSource)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

    }

    #endregion

    private OrderDS OrderDS1;
    internal System.Windows.Forms.BindingSource OrderDetailBindingSource;
    internal System.Windows.Forms.BindingSource OrderBindingSource;
    internal System.Windows.Forms.Label Label4;
    internal System.Windows.Forms.DataGridView DataGridView1;
    internal System.Windows.Forms.Button SaveOrderButton;
    internal System.Windows.Forms.TextBox TextBox2;
    internal System.Windows.Forms.DateTimePicker DateTimePicker1;
    internal System.Windows.Forms.TextBox TextBox1;
    internal System.Windows.Forms.Label Label3;
    internal System.Windows.Forms.Label Label2;
    internal System.Windows.Forms.Label Label1;
    private System.Windows.Forms.DataGridViewTextBoxColumn OrderIdDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn LineNumberDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn ProductIdDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn QuantityDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn PriceDataGridViewTextBoxColumn;

  }
}

