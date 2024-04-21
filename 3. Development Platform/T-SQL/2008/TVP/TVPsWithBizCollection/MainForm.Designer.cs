namespace TVPsWithBizCollection
{
	partial class MainForm
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
			this.RunDemoButton = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// RunDemoButton
			// 
			this.RunDemoButton.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
			this.RunDemoButton.Location = new System.Drawing.Point(18, 20);
			this.RunDemoButton.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.RunDemoButton.Name = "RunDemoButton";
			this.RunDemoButton.Size = new System.Drawing.Size(294, 66);
			this.RunDemoButton.TabIndex = 0;
			this.RunDemoButton.Text = "TVPs using Business Collection";
			this.RunDemoButton.UseVisualStyleBackColor = true;
			this.RunDemoButton.Click += new System.EventHandler(this.RunDemoButton_Click);
			// 
			// MainForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
			this.ClientSize = new System.Drawing.Size(333, 110);
			this.Controls.Add(this.RunDemoButton);
			this.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
			this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
			this.Name = "MainForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "MainForm";
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Button RunDemoButton;
	}
}
