using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

namespace TxtImg.Test
{
    [TestClass]
    public class TextImgTest
    {
        [TestMethod]
        public void ImageToStringShouldConvertImageFoundAtURLToASCIIArt()
        {
            //var url = "http://science-all.com/images/wallpapers/profile-pictures/profile-pictures-12.jpg";
            var url = "https://internal.devel.int/_layouts/15/userphoto.aspx?accountname=contoso\bjorn";
            var data = TxtImg.API.ImageToString(url);
            Debug.WriteLine(data);
            Assert.IsNotNull(data);
            Assert.IsTrue(data.Length > 0);
        }
    }
}
