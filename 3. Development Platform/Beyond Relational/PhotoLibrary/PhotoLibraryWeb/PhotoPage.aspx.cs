using System;
using System.Web.UI;

namespace PhotoLibraryWeb
{
	public partial class PhotoPage : Page
	{
		protected void saveLinkButton_Click(object sender, EventArgs e)
		{
			if (!photoFileUpload.HasFile)
			{
				return;
			}
			var photoId = int.Parse(savePhotoIdTextBox.Text);
			var desc = descriptionTextBox.Text;
			var httpStream = photoFileUpload.FileContent;

			PhotoData.InsertPhoto(photoId, desc, httpStream);
		}

		protected void loadLinkButton_Click(object sender, EventArgs e)
		{
			var photoId = int.Parse(loadPhotoIdTextBox.Text);

			var photoDescription = PhotoData.SelectPhotoDescription(photoId);

			photoImage.ImageUrl = string.Format("/PhotoHandler.ashx?photoId={0}", photoId);
			photoDescriptionLabel.Text = photoDescription;
		}

	}
}
