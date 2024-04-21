using System.IO;
using System.Net.Mime;
using System.Web;

namespace PhotoLibraryWeb
{
	public class PhotoHandler : IHttpHandler
	{
		public void ProcessRequest(HttpContext context)
		{
			var photoId = 0;
			if (!int.TryParse(context.Request.QueryString["photoId"], out photoId))
			{
				return;
			}

			var bytes = PhotoData.SelectPhotoImage(photoId);

			context.Response.ContentType = MediaTypeNames.Image.Jpeg;
			context.Response.BufferOutput = false;
			context.Response.AddHeader("content-length", bytes.Length.ToString());	// not necessary, but nice to let the client know

			using (var ms = new MemoryStream(bytes))
			{
				ms.CopyTo(context.Response.OutputStream);
			}
		}

		public bool IsReusable
		{
			get { return false; }
		}

	}
}
