namespace PhotoLibraryWin
{
	partial class PhotoForm
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
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.saveLinkLabel = new System.Windows.Forms.LinkLabel();
			this.descriptionTextBox = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.filenameTextBox = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.savePhotoIdTextBox = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.photoPictureBox = new System.Windows.Forms.PictureBox();
			this.descriptionLabel = new System.Windows.Forms.Label();
			this.loadLinkLabel = new System.Windows.Forms.LinkLabel();
			this.loadPhotoIdTextBox = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.photoPictureBox)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.saveLinkLabel);
			this.groupBox1.Controls.Add(this.descriptionTextBox);
			this.groupBox1.Controls.Add(this.label3);
			this.groupBox1.Controls.Add(this.filenameTextBox);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Controls.Add(this.savePhotoIdTextBox);
			this.groupBox1.Controls.Add(this.label1);
			this.groupBox1.Location = new System.Drawing.Point(16, 12);
			this.groupBox1.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Padding = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.groupBox1.Size = new System.Drawing.Size(416, 164);
			this.groupBox1.TabIndex = 1;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Insert Photo";
			// 
			// saveLinkLabel
			// 
			this.saveLinkLabel.AutoSize = true;
			this.saveLinkLabel.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.saveLinkLabel.Location = new System.Drawing.Point(20, 128);
			this.saveLinkLabel.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.saveLinkLabel.Name = "saveLinkLabel";
			this.saveLinkLabel.Size = new System.Drawing.Size(43, 21);
			this.saveLinkLabel.TabIndex = 6;
			this.saveLinkLabel.TabStop = true;
			this.saveLinkLabel.Text = "Save";
			this.saveLinkLabel.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.saveLinkLabel_LinkClicked);
			// 
			// descriptionTextBox
			// 
			this.descriptionTextBox.Location = new System.Drawing.Point(148, 60);
			this.descriptionTextBox.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.descriptionTextBox.Name = "descriptionTextBox";
			this.descriptionTextBox.Size = new System.Drawing.Size(252, 29);
			this.descriptionTextBox.TabIndex = 1;
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(20, 60);
			this.label3.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(92, 21);
			this.label3.TabIndex = 4;
			this.label3.Text = "Description:";
			// 
			// filenameTextBox
			// 
			this.filenameTextBox.Location = new System.Drawing.Point(148, 96);
			this.filenameTextBox.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.filenameTextBox.Name = "filenameTextBox";
			this.filenameTextBox.Size = new System.Drawing.Size(252, 29);
			this.filenameTextBox.TabIndex = 2;
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(20, 96);
			this.label2.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(76, 21);
			this.label2.TabIndex = 2;
			this.label2.Text = "Filename:";
			// 
			// savePhotoIdTextBox
			// 
			this.savePhotoIdTextBox.Location = new System.Drawing.Point(148, 28);
			this.savePhotoIdTextBox.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.savePhotoIdTextBox.Name = "savePhotoIdTextBox";
			this.savePhotoIdTextBox.Size = new System.Drawing.Size(76, 29);
			this.savePhotoIdTextBox.TabIndex = 0;
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(20, 28);
			this.label1.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(73, 21);
			this.label1.TabIndex = 0;
			this.label1.Text = "Photo ID:";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.photoPictureBox);
			this.groupBox2.Controls.Add(this.descriptionLabel);
			this.groupBox2.Controls.Add(this.loadLinkLabel);
			this.groupBox2.Controls.Add(this.loadPhotoIdTextBox);
			this.groupBox2.Controls.Add(this.label6);
			this.groupBox2.Location = new System.Drawing.Point(16, 192);
			this.groupBox2.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Padding = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.groupBox2.Size = new System.Drawing.Size(420, 324);
			this.groupBox2.TabIndex = 7;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Select Photo";
			// 
			// photoPictureBox
			// 
			this.photoPictureBox.Location = new System.Drawing.Point(20, 136);
			this.photoPictureBox.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.photoPictureBox.Name = "photoPictureBox";
			this.photoPictureBox.Size = new System.Drawing.Size(304, 172);
			this.photoPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.photoPictureBox.TabIndex = 9;
			this.photoPictureBox.TabStop = false;
			// 
			// descriptionLabel
			// 
			this.descriptionLabel.Location = new System.Drawing.Point(20, 108);
			this.descriptionLabel.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.descriptionLabel.Name = "descriptionLabel";
			this.descriptionLabel.Size = new System.Drawing.Size(388, 26);
			this.descriptionLabel.TabIndex = 8;
			// 
			// loadLinkLabel
			// 
			this.loadLinkLabel.AutoSize = true;
			this.loadLinkLabel.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.loadLinkLabel.Location = new System.Drawing.Point(20, 72);
			this.loadLinkLabel.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.loadLinkLabel.Name = "loadLinkLabel";
			this.loadLinkLabel.Size = new System.Drawing.Size(44, 21);
			this.loadLinkLabel.TabIndex = 7;
			this.loadLinkLabel.TabStop = true;
			this.loadLinkLabel.Text = "Load";
			this.loadLinkLabel.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.loadLinkLabel_LinkClicked);
			// 
			// loadPhotoIdTextBox
			// 
			this.loadPhotoIdTextBox.Location = new System.Drawing.Point(148, 40);
			this.loadPhotoIdTextBox.Margin = new System.Windows.Forms.Padding(5, 4, 5, 4);
			this.loadPhotoIdTextBox.Name = "loadPhotoIdTextBox";
			this.loadPhotoIdTextBox.Size = new System.Drawing.Size(72, 29);
			this.loadPhotoIdTextBox.TabIndex = 0;
			// 
			// label6
			// 
			this.label6.AutoSize = true;
			this.label6.Location = new System.Drawing.Point(20, 40);
			this.label6.Margin = new System.Windows.Forms.Padding(5, 0, 5, 0);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(73, 21);
			this.label6.TabIndex = 0;
			this.label6.Text = "Photo ID:";
			// 
			// PhotoForm
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.ClientSize = new System.Drawing.Size(450, 527);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.groupBox1);
			this.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.Name = "PhotoForm";
			this.Text = "Windows Forms FILESTREAM Demo";
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.groupBox2.ResumeLayout(false);
			this.groupBox2.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.photoPictureBox)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.LinkLabel saveLinkLabel;
		private System.Windows.Forms.TextBox descriptionTextBox;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox filenameTextBox;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox savePhotoIdTextBox;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.PictureBox photoPictureBox;
		private System.Windows.Forms.Label descriptionLabel;
		private System.Windows.Forms.LinkLabel loadLinkLabel;
		private System.Windows.Forms.TextBox loadPhotoIdTextBox;
		private System.Windows.Forms.Label label6;
	}
}

