namespace TxtImg
{
    using System;
    using System.Collections.Generic;
    using System.Drawing;
    using System.IO;
    using System.Net;

    public class API
    {
        // base ramp used as source for characters when rendering the ascii.
        private static readonly string BaseRamp = "MMMMMMM@@@@@@@WWWWWWWWWBBBBBBBB000000008888888ZZZZZZZZZaZaaaaaa2222222SSSSSSSXXXXXXXXXXX7777777rrrrrrr;;;;;;;;iiiiiiiii:::::::,:,,,,,,.........       ";

        /// <summary>
        /// Gets the image at the supplied URL and creates a multi-line string
        /// which is the image's ASCII representaion.
        /// </summary>
        /// <param name="url">The image's URL</param>
        /// <returns>the image as ASCII art</returns>
        public static string ImageToString(string url)
        {
            return string.Join("\n", ImageToStrings(url));
        }

        /// <summary>
        /// fetches an image found at the specified url, and converts it to a list of strings
        /// which represents the image as text.
        /// </summary>
        /// <param name="url">the image's url</param>
        /// <returns>the list of strings containing the ascii representation</returns>
        private static IEnumerable<string> ImageToStrings(string url)
        {
            const double artW = 80.0;
            const double fontApproxWidthToHeightRatio = 40.0 / 80.0;
            var img = Image.FromStream(GetImageStreamFromURL(url));
            var imgW = img.Size.Width;
            var ratio = artW / imgW;
            var artH = ratio * img.Size.Height;

            var w = Convert.ToInt32(artW);
            var h = Convert.ToInt32(artH * fontApproxWidthToHeightRatio);

            var result = TxtImg.ImageHelper.ImageToValues.Convert(img, new Size(w, h));
            var conv = new TxtImg.AsciiConversion.ValuesToFixedWidthTextConverter(BaseRamp);
            return conv.Apply(result);
        }

        /// <summary>
        /// gets the stream from making a http request fetching the image.
        /// </summary>
        /// <param name="url">the image's url</param>
        /// <returns>the stream which will evaluate to the image.</returns>
        private static Stream GetImageStreamFromURL(string url)
        {
            var c = new WebClient();
            c.UseDefaultCredentials = true;
            var stream = c.OpenRead(url);

            return stream;
        }
    }
}
