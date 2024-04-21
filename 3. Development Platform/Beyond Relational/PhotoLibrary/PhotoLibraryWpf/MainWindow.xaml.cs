using System;
using System.Windows;

namespace PhotoLibraryWpf
{
	public partial class MainWindow : Window
	{
		public MainWindow()
		{
			InitializeComponent();
		}

		private void DownloadButton_Click(object sender, RoutedEventArgs e)
		{
			var url = string.Format(
				"http://localhost:1534/PhotoHandler.ashx?photoId={0}",
				PhotoIdTextBox.Text);

			// Requires Windows Media Player v10 or later (for Windows Server, turn on Desktop Experience)
			this.mediaElement1.Source = new Uri(url);
		}

	}
}
