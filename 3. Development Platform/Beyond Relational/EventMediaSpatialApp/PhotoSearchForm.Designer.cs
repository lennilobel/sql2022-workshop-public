namespace EventMediaSpatialApp
{
	partial class PhotoSearchForm
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
			if(disposing && (components != null))
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
			this.picImage = new System.Windows.Forms.PictureBox();
			this.label4 = new System.Windows.Forms.Label();
			this.cboRegions = new System.Windows.Forms.ComboBox();
			this.lnkSearch = new System.Windows.Forms.LinkLabel();
			this.lstPhotos = new System.Windows.Forms.ListBox();
			this.label1 = new System.Windows.Forms.Label();
			this.lnkAddPhotos = new System.Windows.Forms.LinkLabel();
			this.splitContainer1 = new System.Windows.Forms.SplitContainer();
			((System.ComponentModel.ISupportInitialize)(this.picImage)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
			this.splitContainer1.Panel1.SuspendLayout();
			this.splitContainer1.Panel2.SuspendLayout();
			this.splitContainer1.SuspendLayout();
			this.SuspendLayout();
			// 
			// picImage
			// 
			this.picImage.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.picImage.Dock = System.Windows.Forms.DockStyle.Fill;
			this.picImage.Location = new System.Drawing.Point(0, 0);
			this.picImage.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.picImage.Name = "picImage";
			this.picImage.Size = new System.Drawing.Size(630, 217);
			this.picImage.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.picImage.TabIndex = 9;
			this.picImage.TabStop = false;
			// 
			// label4
			// 
			this.label4.AutoSize = true;
			this.label4.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label4.Location = new System.Drawing.Point(20, 13);
			this.label4.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(80, 19);
			this.label4.TabIndex = 4;
			this.label4.Text = "Regions:";
			// 
			// cboRegions
			// 
			this.cboRegions.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cboRegions.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.cboRegions.FormattingEnabled = true;
			this.cboRegions.Location = new System.Drawing.Point(112, 9);
			this.cboRegions.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.cboRegions.Name = "cboRegions";
			this.cboRegions.Size = new System.Drawing.Size(269, 27);
			this.cboRegions.TabIndex = 7;
			// 
			// lnkSearch
			// 
			this.lnkSearch.AutoSize = true;
			this.lnkSearch.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lnkSearch.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.lnkSearch.Location = new System.Drawing.Point(388, 12);
			this.lnkSearch.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.lnkSearch.Name = "lnkSearch";
			this.lnkSearch.Size = new System.Drawing.Size(104, 19);
			this.lnkSearch.TabIndex = 8;
			this.lnkSearch.TabStop = true;
			this.lnkSearch.Text = "Find Photos";
			this.lnkSearch.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkSearch_LinkClicked);
			// 
			// lstPhotos
			// 
			this.lstPhotos.Dock = System.Windows.Forms.DockStyle.Fill;
			this.lstPhotos.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lstPhotos.FormattingEnabled = true;
			this.lstPhotos.ItemHeight = 19;
			this.lstPhotos.Location = new System.Drawing.Point(0, 0);
			this.lstPhotos.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.lstPhotos.Name = "lstPhotos";
			this.lstPhotos.Size = new System.Drawing.Size(630, 107);
			this.lstPhotos.TabIndex = 9;
			this.lstPhotos.SelectedIndexChanged += new System.EventHandler(this.lstPhotos_SelectedIndexChanged);
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label1.Location = new System.Drawing.Point(20, 57);
			this.label1.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(71, 19);
			this.label1.TabIndex = 10;
			this.label1.Text = "Photos:";
			// 
			// lnkAddPhotos
			// 
			this.lnkAddPhotos.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.lnkAddPhotos.AutoSize = true;
			this.lnkAddPhotos.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.lnkAddPhotos.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.lnkAddPhotos.Location = new System.Drawing.Point(560, 12);
			this.lnkAddPhotos.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.lnkAddPhotos.Name = "lnkAddPhotos";
			this.lnkAddPhotos.Size = new System.Drawing.Size(102, 19);
			this.lnkAddPhotos.TabIndex = 11;
			this.lnkAddPhotos.TabStop = true;
			this.lnkAddPhotos.Text = "Add Photos";
			this.lnkAddPhotos.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkAddPhotos_LinkClicked);
			// 
			// splitContainer1
			// 
			this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.splitContainer1.Location = new System.Drawing.Point(25, 80);
			this.splitContainer1.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.splitContainer1.Name = "splitContainer1";
			this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
			// 
			// splitContainer1.Panel1
			// 
			this.splitContainer1.Panel1.Controls.Add(this.lstPhotos);
			// 
			// splitContainer1.Panel2
			// 
			this.splitContainer1.Panel2.Controls.Add(this.picImage);
			this.splitContainer1.Size = new System.Drawing.Size(630, 330);
			this.splitContainer1.SplitterDistance = 107;
			this.splitContainer1.SplitterWidth = 6;
			this.splitContainer1.TabIndex = 12;
			// 
			// PhotoSearchForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
			this.ClientSize = new System.Drawing.Size(675, 428);
			this.Controls.Add(this.splitContainer1);
			this.Controls.Add(this.lnkAddPhotos);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.lnkSearch);
			this.Controls.Add(this.cboRegions);
			this.Controls.Add(this.label4);
			this.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.Name = "PhotoSearchForm";
			this.Text = "PhotoForm";
			((System.ComponentModel.ISupportInitialize)(this.picImage)).EndInit();
			this.splitContainer1.Panel1.ResumeLayout(false);
			this.splitContainer1.Panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
			this.splitContainer1.ResumeLayout(false);
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.PictureBox picImage;
        private System.Windows.Forms.ComboBox cboRegions;
        private System.Windows.Forms.LinkLabel lnkSearch;
        private System.Windows.Forms.ListBox lstPhotos;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.LinkLabel lnkAddPhotos;
        private System.Windows.Forms.SplitContainer splitContainer1;
	}
}
