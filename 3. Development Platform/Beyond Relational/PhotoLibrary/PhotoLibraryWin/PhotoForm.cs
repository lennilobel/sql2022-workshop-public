using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace PhotoLibraryWin
{
	public partial class PhotoForm : Form
	{
		public PhotoForm()
		{
			InitializeComponent();
		}

		private void saveLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			System.Diagnostics.Debugger.Break();

			var photoId = int.Parse(savePhotoIdTextBox.Text);
			var desc = descriptionTextBox.Text;
			var filename = filenameTextBox.Text;

			if (!File.Exists(filename))
			{
				MessageBox.Show("File not found", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}

			PhotoData.InsertPhoto(photoId, desc, filename);
			MessageBox.Show("Photo has been added to the database", "Photo added", MessageBoxButtons.OK, MessageBoxIcon.Information);
		}

		private void loadLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			System.Diagnostics.Debugger.Break();

			var photoId = int.Parse(loadPhotoIdTextBox.Text);
			var photoData = PhotoData.SelectPhoto(photoId);

			descriptionLabel.Text = photoData.Description;
			photoPictureBox.Image = Image.FromStream(new MemoryStream(photoData.Photo));
		}

	}
}
